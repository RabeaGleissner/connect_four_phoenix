defmodule ConnectGameWeb.GameControllerTest do
  use ConnectGameWeb.ConnCase
  alias ConnectGame.App

  import ConnectGame.AppFixtures

  describe "index page" do
    test "renders homepage with play button", %{conn: conn} do
      conn = get(conn, "/")

      assert html_response(conn, 200) =~ "Connect"

      start_button_text =
        html_response(conn, 200)
        |> Floki.find("button[type='submit']")
        |> Floki.text()

      assert start_button_text == "Play"
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

      refute new_game.ended
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

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
