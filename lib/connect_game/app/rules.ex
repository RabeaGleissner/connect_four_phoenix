defmodule ConnectGame.App.Rules do
  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  def handle_move(%Game{} = game, column, config) do
    if game.ended do
      {:error, "Game is over!"}
    else
      transformed_moves = Move.transform(game.moves)
      {:ok, current_player} = ConnectFour.next_player_turn(transformed_moves)
      coordinates = ConnectFour.next_slot_in_column(column, transformed_moves)

      game_state =
        ConnectFour.game_state(
          moves: [{current_player, coordinates} | transformed_moves],
          current_player: [player_id: current_player, current_move: coordinates],
          config: config
        )

      {:ok, %{game_state: game_state, coordinates: coordinates, current_player: current_player}}
    end
  end

  def is_drawn?(%Game{ended: ended, winner: winner}) do
    ended && !winner
  end

  def current_player(moves) do
    {:ok, current_player} = ConnectFour.next_player_turn(Move.transform(moves))
    current_player
  end

  def column_has_space?(moves, column_index, grid_height) do
    moves
    |> Enum.filter(fn move -> move.y_coordinate == column_index end)
    |> length() < grid_height
  end
end
