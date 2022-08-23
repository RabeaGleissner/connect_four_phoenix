defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

  def game_state(game) do
    case game.ended do
      true -> "Game over!"
      false -> "Game in progress"
    end
  end

  def transform_move({player, coordinates}) do
    pretty_coordinates = coordinates
                         |> Tuple.to_list()
                         |> Enum.join(", ")
    "#{player}: #{pretty_coordinates}"
  end
end
