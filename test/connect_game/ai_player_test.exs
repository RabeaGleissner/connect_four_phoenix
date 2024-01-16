defmodule ConnectGame.AiPlayerTest do
  use ConnectGame.DataCase

  alias ConnectGame.App.AiPlayer

  describe "AI Player" do
    def mock_random_number_generator(_, _) do
      1
    end

    test "picks a column" do
      column = AiPlayer.choose_column([], 3, &mock_random_number_generator/2)

      assert column == 1
    end
  end
end
