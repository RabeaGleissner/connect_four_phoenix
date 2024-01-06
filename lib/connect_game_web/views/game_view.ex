defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

  alias ConnectGame.App.Game

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
      moves: game.moves,
      ended: game.ended,
      winner: game.winner
    }
  end

  defp player_id_to_colour("one"), do: "Blue"
  defp player_id_to_colour("two"), do: "Red"
end
