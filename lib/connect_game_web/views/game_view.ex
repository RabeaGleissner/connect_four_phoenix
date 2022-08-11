defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

  def game_state(game) do
    case game.ended do
      true -> "Game over!"
      false -> "Game in progress"
    end
  end
end
