defmodule ConnectGame.RulesTest do
  use ConnectGame.DataCase
  alias ConnectGame.App.Rules

  import ConnectGame.AppFixtures

  describe "Rules" do
    test "a game has ended with a draw" do
      game = game_fixture(%{ended: true, winner: nil})

      is_drawn = Rules.is_drawn?(game)

      assert is_drawn
    end

    test "a game has ended with a winner" do
      game = game_fixture(%{ended: true, winner: "yellow"})

      is_drawn = Rules.is_drawn?(game)

      refute is_drawn
    end
  end
end
