defmodule ConnectGameWeb.MoveControllerTest do
  use ConnectGameWeb.ConnCase

  import ConnectGame.AppFixtures

  @create_attrs %{coordinates: "some coordinates", player: "some player"}
  @update_attrs %{coordinates: "some updated coordinates", player: "some updated player"}
  @invalid_attrs %{coordinates: nil, player: nil}

  describe "index" do
    test "lists all moves", %{conn: conn} do
      conn = get(conn, Routes.move_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Moves"
    end
  end

  describe "new move" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.move_path(conn, :new))
      assert html_response(conn, 200) =~ "New Move"
    end
  end

  describe "create move" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.move_path(conn, :create), move: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.move_path(conn, :show, id)

      conn = get(conn, Routes.move_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Move"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.move_path(conn, :create), move: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Move"
    end
  end

  describe "edit move" do
    setup [:create_move]

    test "renders form for editing chosen move", %{conn: conn, move: move} do
      conn = get(conn, Routes.move_path(conn, :edit, move))
      assert html_response(conn, 200) =~ "Edit Move"
    end
  end

  describe "update move" do
    setup [:create_move]

    test "redirects when data is valid", %{conn: conn, move: move} do
      conn = put(conn, Routes.move_path(conn, :update, move), move: @update_attrs)
      assert redirected_to(conn) == Routes.move_path(conn, :show, move)

      conn = get(conn, Routes.move_path(conn, :show, move))
      assert html_response(conn, 200) =~ "some updated player"
    end

    test "renders errors when data is invalid", %{conn: conn, move: move} do
      conn = put(conn, Routes.move_path(conn, :update, move), move: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Move"
    end
  end

  describe "delete move" do
    setup [:create_move]

    test "deletes chosen move", %{conn: conn, move: move} do
      conn = delete(conn, Routes.move_path(conn, :delete, move))
      assert redirected_to(conn) == Routes.move_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.move_path(conn, :show, move))
      end
    end
  end

  defp create_move(_) do
    move = move_fixture()
    %{move: move}
  end
end
