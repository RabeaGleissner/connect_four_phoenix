defmodule ConnectGameWeb.GameControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App
  alias ConnectGame.App.Game

  import ConnectGame.AppFixtures

  describe "index page" do
    test "renders homepage with play button", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Play a new game"

      start_button_text =
        html_response(conn, 200)
        |> Floki.find("button[type='submit']")
        |> Floki.text()

      assert start_button_text == "Start"
    end

    test "does not list games when there are none", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "--.--"
    end

    test "lists all games", %{conn: conn} do
      %{game: first_game} = create_game(%{ended: false, winner: nil})
      %{game: second_game} = create_game(%{ended: true, winner: "a winner"})

      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Games in progress"
      assert html_response(conn, 200) =~ "Completed games"
      assert html_response(conn, 200) =~ "Game #{first_game.id}"
      assert html_response(conn, 200) =~ "Game #{second_game.id}"
    end
  end

  describe "create game" do
    test "redirects to show template after game creation", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_path(conn, :show, id)
      new_game = App.get_game!(id)

      assert new_game.ended == false
      assert new_game.winner == nil
    end
  end

  describe "show game" do
    test "renders heading", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = get(conn, Routes.game_path(conn, :show, game.id))

      heading_text =
        html_response(conn, 200)
        |> Floki.find("h1")
        |> Floki.text()

      assert heading_text == "Game #{game.id}"
    end
  end

  describe "show game api data" do
    test "when there are no moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = get(conn, Routes.game_path(conn, :show_api, game.id))

      assert json_response(conn, 200)["data"]["id"] == game.id
      assert json_response(conn, 200)["data"]["ended"] == false
      assert json_response(conn, 200)["data"]["winner"] == nil
      assert json_response(conn, 200)["data"]["grid_height"] == Game.grid_height()
      assert json_response(conn, 200)["data"]["grid_width"] == Game.grid_width()
      assert json_response(conn, 200)["data"]["connect_what"] == Game.connect_what()
      assert json_response(conn, 200)["data"]["draw"] == false
    end

    test "with moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      {:ok, _} =
        App.create_move(%{
          x_coordinate: 0,
          y_coordinate: 0,
          player: Atom.to_string(:one),
          game: game
        })

      {:ok, _} =
        App.create_move(%{
          x_coordinate: 0,
          y_coordinate: 1,
          player: Atom.to_string(:two),
          game: game
        })

      conn = get(conn, Routes.game_path(conn, :show_api, game.id))

      assert decode_json_data(conn)["id"] == game.id
      assert decode_json_data(conn)["ended"] == false
      assert decode_json_data(conn)["winner"] == nil

      returned_moves = decode_json_data(conn)["moves"]
      assert length(returned_moves) == 2
      assert List.first(returned_moves)["player"] == "one"
      assert List.first(returned_moves)["x_coordinate"] == 0
      assert List.first(returned_moves)["y_coordinate"] == 0
    end
  end

  describe "create move via API" do
    test "creates move for existing game", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = post(conn, Routes.game_path(conn, :create_move_api, game.id), %{column: 0})

      assert json_response(conn, 200)["data"]["ended"] == false
      assert json_response(conn, 200)["data"]["winner"] == nil
    end

    test "updates game in database when game has a winner", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      create_move(game, 0, 0, :one)
      create_move(game, 0, 5, :two)
      create_move(game, 1, 0, :one)
      create_move(game, 0, 4, :two)
      create_move(game, 2, 0, :one)
      create_move(game, 0, 2, :two)

      conn = post(conn, Routes.game_path(conn, :create_move_api, game.id), %{column: 0})

      assert json_response(conn, 200)["data"]["ended"] == true
      assert json_response(conn, 200)["data"]["winner"] == "one"
    end

    test "updates game in database when game is a draw", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      create_41_moves(game)

      conn = post(conn, Routes.game_path(conn, :create_move_api, game.id), %{column: 0})

      assert json_response(conn, 200)["data"]["ended"] == true
      assert json_response(conn, 200)["data"]["winner"] == nil
    end

    test "does not allow move when game has ended", %{conn: conn} do
      ended_game = game_fixture(%{ended: true, winner: "red"})
      conn = post(conn, Routes.game_path(conn, :create_move_api, ended_game.id), %{column: 0})

      assert json_response(conn, 400)["error"] == "Game over! Not allowed to create a move."
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end

  defp decode_json_data(conn) do
    json_response(conn, 200)["data"]
  end

  defp create_move(game, x, y, player) do
    {:ok, _} =
      App.create_move(%{
        x_coordinate: x,
        y_coordinate: y,
        player: Atom.to_string(player),
        game: game
      })
  end

  defp create_41_moves(game) do
    for row <- 0..5 do
      for column <- 0..5 do
        create_move(game, row, column, :one)
      end
    end

    for column <- 0..4 do
      create_move(game, 6, column, :two)
    end
  end
end
