defmodule ConnectGameWeb.PageController do
  use ConnectGameWeb, :controller
  alias ConnectGame.App

  def index(conn, _params) do
    games = App.list_games()
    render(conn, "index.html", games: games)
  end
end
