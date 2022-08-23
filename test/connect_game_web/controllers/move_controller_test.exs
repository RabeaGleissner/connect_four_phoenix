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

    @tag :pending
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.game_move_path(conn, :create, 1), %{column: nil})
      assert html_response(conn, 200) =~ "New Move"
    end
  end
end
