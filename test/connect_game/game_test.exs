defmodule ConnectGame.GameTest do
  use ConnectGame.DataCase

  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  describe "Game" do
    test "transforms move coordinates from binary to tuple" do
      move_1 = %Move{
        coordinates: :erlang.term_to_binary({0, 0}),
        game_id: 1,
        id: 1,
        player: "blue",
      }

      move_2 = %Move{
        coordinates: :erlang.term_to_binary({1, 3}),
        game_id: 1,
        id: 2,
        player: "red",
      }
      game = %Game{
        ended: false,
        moves: [move_1, move_2],
        winner: nil
      }

      %{moves: moves} = Game.transform_coordinates(game)

      assert List.first(moves) == {0 , 0}
      assert List.last(moves) == {1 , 3}
    end
  end
end
