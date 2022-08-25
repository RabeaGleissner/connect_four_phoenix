defmodule ConnectGameWeb.MoveControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App

  describe "create move" do
    test "creates move for existing game", %{conn: conn} do
      {:ok, game}= App.create_game(%{ended: false, winner: ""})
      conn = post(conn, Routes.game_move_path(conn, :create, game.id), %{column: "0"})

      assert redirected_to(conn) == Routes.game_path(conn, :show, game.id)

      conn = get(conn, Routes.game_path(conn, :show, game.id))
      assert html_response(conn, 200) =~ "<li>one: 0, 0</li>"
    end

    test "updates game in database when game has a winner", %{conn: conn} do
      {:ok, game}= App.create_game(%{ended: false, winner: ""})

      create_move(game, 0, 0, :one)
      create_move(game, 0, 5, :two)
      create_move(game, 1, 0, :one)
      create_move(game, 0, 4, :two)
      create_move(game, 2, 0, :one)
      create_move(game, 0, 2, :two)

      post(conn, Routes.game_move_path(conn, :create, game.id), %{column: "0"})

      updated_game = App.get_game!(game.id)
      assert updated_game.ended
      assert updated_game.winner == "one"
    end

    test "updates game in database when game is a draw", %{conn: conn} do
      {:ok, game}= App.create_game(%{ended: false, winner: ""})

      create_41_moves(game)

      post(conn, Routes.game_move_path(conn, :create, game.id), %{column: "0"})

      updated_game = App.get_game!(game.id)
      assert updated_game.ended
      assert updated_game.winner == nil
    end

    @tag :pending
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_move_path(conn, :create, 1), %{column: nil})
      assert html_response(conn, 200) =~ "New Move"
    end
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
