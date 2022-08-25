defmodule ConnectGame.MoveTest do
  use ConnectGame.DataCase

  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  describe "Move" do
    test "transform" do
      move_1 = %Move{
        x_coordinate: 1,
        y_coordinate: 1,
        game_id: 1,
        id: 1,
        player: "one",
      }

      move_2 = %Move{
        x_coordinate: 2,
        y_coordinate: 3,
        game_id: 1,
        id: 2,
        player: "two",
      }

      transformed_moves = Move.transform([move_1, move_2])

      assert List.first(transformed_moves) == {:one, {1, 1}}
      assert List.last(transformed_moves) == {:two, {2, 3}}
    end
  end

end
