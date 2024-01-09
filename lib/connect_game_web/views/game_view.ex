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

  def game_state(game) do
    case game.ended do
      true ->
        if (game.winner) do
          "Game over. #{player_id_to_colour(game.winner)} won!"
        else
          "Game over. It's a draw."
        end
      false -> "Game in progress"
    end
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
      grid_width: Game.grid_width,
      grid_height: Game.grid_height,
      connect_what: Game.connect_what
    }
  end

  defp player_id_to_colour("one"), do: "Blue"
  defp player_id_to_colour("two"), do: "Red"
end
