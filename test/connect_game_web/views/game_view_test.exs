defmodule ConnectGameWeb.GameViewTest do
  use ConnectGameWeb.ConnCase, async: true

  alias ConnectGameWeb.GameView
  alias ConnectGame.App.Game

  test "returns completed games" do
    game_1 = %Game{id: "1", winner: "The winner", ended: true}
    game_2 = %Game{id: "2", winner: nil, ended: false}

    [game] = GameView.completed_games([game_1, game_2])

    assert game.ended
    assert game.winner == "The winner"
  end

  test "returns in-progress games" do
    game_1 = %Game{id: "1", winner: nil, ended: false}
    game_2 = %Game{id: "2", winner: "a winner", ended: true}
    game_3 = %Game{id: "3", winner: nil, ended: false}

    games = GameView.in_progress_games([game_1, game_2, game_3])

    assert length(games) == 2
    [first_game, second_game] = games
    refute first_game.ended
    refute second_game.ended
  end
end
