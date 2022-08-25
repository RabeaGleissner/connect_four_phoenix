defmodule ConnectGameWeb.GameViewTest do
  use ConnectGameWeb.ConnCase, async: true
  alias ConnectGameWeb.GameView

  test "Returns game state for in progress game" do
    game = %{id: "1", winner: nil, ended: false}
    assert GameView.game_state(game) == "Game in progress"
  end

  test "Returns game state for drawn game" do
    game = %{id: "1", winner: nil, ended: true}
    assert GameView.game_state(game) == "Game over. It's a draw."
  end

  test "Returns game state for won game" do
    game = %{id: "1", winner: "one", ended: true}
    assert GameView.game_state(game) == "Game over. Blue won!"
  end
end
