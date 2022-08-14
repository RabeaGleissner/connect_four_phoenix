defmodule ConnectGameWeb.MoveControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App

  @invalid_attrs %{coordinates: nil, player: nil}

  describe "index" do
    test "lists all moves", %{conn: conn} do
      conn = get(conn, Routes.move_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Moves"
    end
  end

  describe "create move" do
    test "creates move for existing game", %{conn: conn} do
      {:ok, game}= App.create_game(%{ended: false, winner: ""})
      move_attrs = %{coordinates: {2, 0}, player: "blue", game_id: game.id}
      conn = post(conn, Routes.move_path(conn, :create), move: move_attrs)

      assert redirected_to(conn) == Routes.game_path(conn, :show, game.id)

      conn = get(conn, Routes.game_path(conn, :show, game.id))
      assert html_response(conn, 200) =~ "<li>2, 0</li>"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.move_path(conn, :create), move: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Move"
    end
  end
end
