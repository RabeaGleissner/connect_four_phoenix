defmodule ConnectGameWeb.GameControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App

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
    test "displays all game moves", %{conn: conn} do
      {:ok, game} = App.create_game(%{ended: false, winner: ""})
      {:ok, _} = App.create_move(%{
        coordinates: :erlang.term_to_binary({0,0}),
        player: Atom.to_string(:one),
        game: game
      })
      {:ok, _} = App.create_move(%{
        coordinates: :erlang.term_to_binary({0,1}),
        player: Atom.to_string(:two),
        game: game
      })
      conn = get(conn, Routes.game_path(conn, :show, game.id))

      assert html_response(conn, 200) =~ "<li>one: 0, 0</li>"
      assert html_response(conn, 200) =~ "<li>two: 0, 1</li>"
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
end
