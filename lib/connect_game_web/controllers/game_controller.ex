defmodule ConnectGameWeb.GameController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Game

  def index(conn, _params) do
    games = App.list_games()
    render(conn, "index.html", games: games)
  end

  def create(conn, game_params) do
    case App.create_game(game_params) do
      {:ok, game} ->
        conn
        |> redirect(to: Routes.game_path(conn, :show, game))
    end
  end

  def show(conn, %{"id" => id}) do
    game = App.get_game_for_view!(id)

    render(conn, "show.html",
      game: game,
      grid_width: Game.grid_width(),
      grid_height: Game.grid_height()
    )
  end
end
