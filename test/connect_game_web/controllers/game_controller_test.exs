defmodule ConnectGameWeb.GameControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App
  alias ConnectGame.App.Game

  import ConnectGame.AppFixtures

  @create_attrs %{ended: true, winner: "some winner"}
  @update_attrs %{ended: false, winner: "some updated winner"}
  @invalid_attrs %{ended: nil, winner: nil}

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, Routes.game_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "create game" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.game_path(conn, :show, id)

      conn = get(conn, Routes.game_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Game #{id}"
      assert html_response(conn, 200) =~ "Game in progress"
    end
  end

  describe "show game" do
    test "when there are no moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = get(conn, Routes.game_path(conn, :show, game.id))

      heading_text = html_response(conn, 200)
                     |> Floki.find("h2")
                     |> Floki.text
      assert heading_text == "Game #{game.id}"
    end

    test "displays all game moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})
      {:ok, _} = App.create_move(%{
        x_coordinate: 0,
        y_coordinate: 0,
        coordinates: :erlang.term_to_binary({0,0}),
        player: Atom.to_string(:one),
        game: game
      })
      {:ok, _} = App.create_move(%{
        x_coordinate: 0,
        y_coordinate: 1,
        coordinates: :erlang.term_to_binary({0,1}),
        player: Atom.to_string(:two),
        game: game
      })
      conn = get(conn, Routes.game_path(conn, :show, game.id))

      assert html_response(conn, 200) =~ "<li>one: 0, 0</li>"
      assert html_response(conn, 200) =~ "<li>two: 0, 1</li>"
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
    end

    test "with moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})
      {:ok, _} = App.create_move(%{
        x_coordinate: 0,
        y_coordinate: 0,
        coordinates: :erlang.term_to_binary({0,0}),
        player: Atom.to_string(:one),
        game: game
      })
      {:ok, _} = App.create_move(%{
        x_coordinate: 0,
        y_coordinate: 1,
        coordinates: :erlang.term_to_binary({0,1}),
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
      {:ok, game}= App.create_game(%{ended: false, winner: ""})

      conn = post(conn, Routes.game_path(conn, :create_move_api, game.id), %{column: 0})

      assert json_response(conn, 200)["data"]["ended"] == false
      assert json_response(conn, 200)["data"]["winner"] == nil
    end

    test "updates game in database when game has a winner", %{conn: conn} do
      {:ok, game}= App.create_game(%{ended: false, winner: ""})

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
      {:ok, game}= App.create_game(%{ended: false, winner: ""})

      create_41_moves(game)

      conn = post(conn, Routes.game_path(conn, :create_move_api, game.id), %{column: 0})

      assert json_response(conn, 200)["data"]["ended"] == true
      assert json_response(conn, 200)["data"]["winner"] == nil
    end
  end


  describe "edit game" do
    setup [:create_game]

    test "renders form for editing chosen game", %{conn: conn, game: game} do
      conn = get(conn, Routes.game_path(conn, :edit, game))
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "update game" do
    setup [:create_game]

    test "redirects when data is valid", %{conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @update_attrs)
      assert redirected_to(conn) == Routes.game_path(conn, :show, game)

      conn = get(conn, Routes.game_path(conn, :show, game))
      assert html_response(conn, 200) =~ "some updated winner"
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, Routes.game_path(conn, :update, game), game: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, Routes.game_path(conn, :delete, game))
      assert redirected_to(conn) == Routes.game_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.game_path(conn, :show, game))
      end
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
    {:ok, _} = App.create_move(%{
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
