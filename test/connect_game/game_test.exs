defmodule ConnectGame.GameTest do
  use ConnectGame.DataCase

  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  describe "Game" do
    test "transforms moves" do
      move_1 = %Move{
        coordinates: :erlang.term_to_binary({0, 0}),
        game_id: 1,
        id: 1,
        player: "one",
      }

      move_2 = %Move{
        coordinates: :erlang.term_to_binary({1, 3}),
        game_id: 1,
        id: 2,
        player: "two",
      }
      game = %Game{
        ended: false,
        moves: [move_1, move_2],
        winner: nil,
        id: 1
      }

      %{moves: moves} = Game.transform_moves(game)

      assert List.first(moves) == {:one, {0 , 0}}
      assert List.last(moves) == {:two, {1 , 3}}
    end
  end
end
