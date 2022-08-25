defmodule ConnectGameWeb.GameViewTest do
  use ConnectGameWeb.ConnCase, async: true
  alias ConnectGameWeb.GameView

  test "formats 'in progress' state" do
    state = {:in_progress}
    assert GameView.format_state(state) == "Game in progress"
  end

  test "formats 'winner :one' state" do
    state = {:won, [winner_id: :one]}
    assert GameView.format_state(state) == "Game over. Blue won!"
  end

  test "formats 'winner :two' state" do
    state = {:won, [winner_id: :two]}
    assert GameView.format_state(state) == "Game over. Red won!"
  end

  test "formats 'draw' state" do
    state = {:draw}
    assert GameView.format_state(state) == "Game over. It's a draw."
  end
end
