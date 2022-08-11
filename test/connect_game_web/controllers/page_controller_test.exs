defmodule ConnectGameWeb.PageControllerTest do
  use ConnectGameWeb.ConnCase

  import ConnectGame.AppFixtures

  test "renders homepage with play button", %{conn: conn} do
    conn = get(conn, "/")

    assert html_response(conn, 200) =~ "Play a new game"
    assert html_response(conn, 200) =~ "<button type=\"submit\">Start</button>"
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

  defp create_game(attributes) do
    game = game_fixture(attributes)
    %{game: game}
  end
end
