defmodule ConnectGameWeb.PageViewTest do
  use ConnectGameWeb.ConnCase, async: true
  alias ConnectGameWeb.PageView

  test "Returns completed games" do
    game_1 = %{id: "1", winner: "The winner", ended: true}
    game_2 = %{id: "2", winner: nil, ended: false}

    [game] = PageView.completed_games([game_1, game_2])

    assert game.ended
    assert game.winner == "The winner"
  end

  test "Returns in-progress games" do
    game_1 = %{id: "1", winner: nil, ended: false}
    game_2 = %{id: "2", winner: "a winner", ended: true}
    game_3 = %{id: "3", winner: nil, ended: false}

    games = PageView.in_progress_games([game_1, game_2, game_3])

    assert length(games) == 2
    [first_game, second_game] = games
    refute first_game.ended
    refute second_game.ended
  end
end
