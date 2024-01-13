defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

  alias ConnectGame.App.Game
  alias ConnectGameWeb.MoveView

  def completed_games(games) do
    games |> Enum.filter(fn game -> game.ended end)
  end

  def in_progress_games(games) do
    games |> Enum.reject(fn game -> game.ended end)
  end

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
