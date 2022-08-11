defmodule ConnectGameWeb.PageView do
  use ConnectGameWeb, :view

  def completed_games(games) do
    games |> Enum.filter(fn game -> game.ended end)
  end

  def in_progress_games(games) do
    games |> Enum.reject(fn game -> game.ended end)
  end
end
