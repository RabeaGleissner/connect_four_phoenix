defmodule ConnectGameWeb.GameView do
  use ConnectGameWeb, :view

  def format_state(state) do
    case state do
      {:won, [winner_id: :one]} -> "Game over. Blue won!"
      {:won, [winner_id: :two]} -> "Game over. Red won!"
      {:draw} -> "Game over. It's a draw."
      {:in_progress} -> "Game in progress"
    end
  end
end
