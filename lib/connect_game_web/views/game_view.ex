defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

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

  defp player_id_to_colour("one"), do: "Blue"
  defp player_id_to_colour("two"), do: "Red"
end
