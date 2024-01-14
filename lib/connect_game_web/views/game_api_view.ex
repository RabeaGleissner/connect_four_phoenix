defmodule ConnectGameWeb.GameApiView do
  use ConnectGameWeb, :view

  alias ConnectGame.App.Game
  alias ConnectGameWeb.MoveView

  def render("show.json", %{game: game}) do
    %{data: data(game)}
  end

  defp data(%Game{} = game) do
    %{
      id: game.id,
      ended: game.ended,
      winner: game.winner,
      moves: render_many(game.moves, MoveView, "move.json"),
      grid_width: Game.grid_width(),
      grid_height: Game.grid_height(),
      connect_what: Game.connect_what(),
      draw: game.draw,
      current_player: game.current_player
    }
  end
end
