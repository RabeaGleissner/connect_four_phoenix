defmodule ConnectGameWeb.GameApiControllerTest do
  use ConnectGameWeb.ConnCase

  alias ConnectGame.App
  alias ConnectGame.App.Game

  import ConnectGame.AppFixtures

  describe("show game data") do
    test "when there are no moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = get(conn, Routes.game_api_path(conn, :show, game.id))

      assert decode_json_data(conn)["id"] == game.id
      assert decode_json_data(conn)["winner"] == nil
      assert decode_json_data(conn)["grid_height"] == Game.grid_height()
      assert decode_json_data(conn)["grid_width"] == Game.grid_width()
      assert decode_json_data(conn)["connect_what"] == Game.connect_what()
      assert decode_json_data(conn)["current_player"] == "one"
      refute decode_json_data(conn)["draw"]
      refute decode_json_data(conn)["ended"]
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

      conn = get(conn, Routes.game_api_path(conn, :show, game.id))

      assert decode_json_data(conn)["id"] == game.id
      assert decode_json_data(conn)["winner"] == nil
      assert decode_json_data(conn)["current_player"] == "one"
      refute decode_json_data(conn)["ended"]

      returned_moves = decode_json_data(conn)["moves"]
      assert length(returned_moves) == 2
      assert List.first(returned_moves)["player"] == "one"
      assert List.first(returned_moves)["x_coordinate"] == 0
      assert List.first(returned_moves)["y_coordinate"] == 0
    end
  end

  describe "creating moves" do
    test "creates move for existing game", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = post(conn, Routes.game_api_path(conn, :create_move, game.id), %{column: 0})

      refute json_response(conn, 200)["data"]["ended"]
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

      conn = post(conn, Routes.game_api_path(conn, :create_move, game.id), %{column: 0})

      assert decode_json_data(conn)["ended"]
      assert decode_json_data(conn)["winner"] == "one"

      updated_game = App.get_game!(game.id)

      assert updated_game.ended
      assert updated_game.winner == "one"
    end

    test "updates game in database when game is a draw", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      create_41_moves(game)

      conn = post(conn, Routes.game_api_path(conn, :create_move, game.id), %{column: 0})

      assert decode_json_data(conn)["ended"]
      assert decode_json_data(conn)["winner"] == nil
      assert decode_json_data(conn)["draw"]

      update_game = App.get_game!(game.id)

      assert update_game.ended == true
      assert update_game.winner == nil
    end

    test "does not allow move when game has ended", %{conn: conn} do
      ended_game = game_fixture(%{ended: true, winner: "red"})
      conn = post(conn, Routes.game_api_path(conn, :create_move, ended_game.id), %{column: 0})

      assert json_response(conn, 400)["error"] == "Game over! Not allowed to create a move."
    end
  end

  describe "AI move action" do
    test "creates a new move when there is space in all columns", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})

      conn = post(conn, Routes.game_api_path(conn, :create_ai_move, game.id))

      moves = decode_json_data(conn)["moves"]
      assert length(moves) == 1
      assert List.last(moves)["player"] == "one"

      refute decode_json_data(conn)["ended"]
      assert decode_json_data(conn)["winner"] == nil
    end

    test "updates game in database when game has ended", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: "", draw: false})
      create_41_moves(game)

      conn = post(conn, Routes.game_api_path(conn, :create_ai_move, game.id))

      moves = decode_json_data(conn)["moves"]
      assert length(moves) == 42

      %{
        "x_coordinate" => x_coordinate,
        "y_coordinate" => y_coordinate,
        "id" => _,
        "player" => player
      } =
        List.last(moves)

      assert x_coordinate == 0
      assert y_coordinate == 6
      assert player == "two"
      assert decode_json_data(conn)["ended"]
      assert decode_json_data(conn)["draw"]
      assert decode_json_data(conn)["winner"] == nil

      updated_game = App.get_game!(game.id)

      assert updated_game.ended
    end
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
