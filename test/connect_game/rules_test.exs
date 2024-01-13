defmodule ConnectGame.RulesTest do
  use ConnectGame.DataCase
  alias ConnectGame.App.Rules
  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  import ConnectGame.AppFixtures

  describe "Rules" do
    test "returns error if the game has ended" do
      game = game_fixture(%{ended: true, winner: nil})

      {:error, message} = Rules.handle_move(game, 1, default_game_config())
      assert message == "Game is over!"
    end

    test "returns current player, coordinates and in progress game state" do
      game_id = 9

      game = %Game{
        id: game_id,
        ended: false,
        winner: nil,
        draw: false,
        moves: [%Move{id: 39, x_coordinate: 0, y_coordinate: 3, player: "one", game_id: game_id}]
      }

      {:ok, %{game_state: game_state, coordinates: coordinates, current_player: current_player}} =
        Rules.handle_move(game, 5, default_game_config())

      assert coordinates == {0, 5}
      assert current_player == :two
      assert game_state == {:in_progress}
    end

    test "returns drawn game state" do
      game_id = 888
      small_grid_config = [connect_what: 3, grid_height: 2, grid_width: 2]

      moves = [
        %Move{id: 1, x_coordinate: 0, y_coordinate: 0, player: "one", game_id: game_id},
        %Move{id: 2, x_coordinate: 0, y_coordinate: 1, player: "two", game_id: game_id},
        %Move{id: 3, x_coordinate: 1, y_coordinate: 0, player: "one", game_id: game_id}
      ]

      new_game = %Game{
        id: game_id,
        ended: false,
        winner: nil,
        draw: false,
        moves: moves
      }

      {:ok, %{game_state: game_state, coordinates: coordinates, current_player: _current_player}} =
        Rules.handle_move(new_game, 1, small_grid_config)

      assert coordinates == {1, 1}
      assert game_state == {:draw}
    end

    test "returns won game state" do
      game_id = 888
      small_grid_config = [connect_what: 2, grid_height: 2, grid_width: 2]

      moves = [
        %Move{id: 1, x_coordinate: 0, y_coordinate: 0, player: "one", game_id: game_id},
        %Move{id: 2, x_coordinate: 0, y_coordinate: 1, player: "two", game_id: game_id},
        %Move{id: 3, x_coordinate: 1, y_coordinate: 0, player: "one", game_id: game_id}
      ]

      new_game = %Game{
        id: game_id,
        ended: false,
        winner: nil,
        draw: false,
        moves: moves
      }

      {:ok, %{game_state: game_state, coordinates: coordinates, current_player: _current_player}} =
        Rules.handle_move(new_game, 1, small_grid_config)

      assert coordinates == {1, 1}
      assert game_state == {:won, [winner_id: :two]}
    end

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

  defp default_game_config do
    [
      connect_what: Game.connect_what(),
      grid_height: Game.grid_height(),
      grid_width: Game.grid_width()
    ]
  end
end
