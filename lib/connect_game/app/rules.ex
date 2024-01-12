defmodule ConnectGame.App.Rules do
  alias ConnectGame.App.Game

  def is_drawn?(%Game{ended: ended, winner: winner}) do
    ended && !winner
  end
end
