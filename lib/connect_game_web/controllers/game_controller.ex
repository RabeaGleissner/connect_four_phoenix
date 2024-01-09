defmodule ConnectGameWeb.GameController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  def index(conn, _params) do
    games = App.list_games()
    render(conn, "index.html", games: games)
  end

  def create(conn, game_params) do
    case App.create_game(game_params) do
      {:ok, game} ->
        conn
        |> redirect(to: Routes.game_path(conn, :show, game))
    end
  end

  def show(conn, %{"id" => id}) do
    game = id
           |> App.get_game!()
    render(conn, "show.html", game: game, grid_width: Game.grid_width, grid_height: Game.grid_height)
  end

  def show_api(conn, %{"id" => id}) do
    game = id
           |> App.get_game!()
    render(conn, "show.json", game: game)
  end

  def create_move_api(conn, params) do
    %{"column" => column, "id" => id} = params
    game = App.get_game!(id)
    transformed_moves = Move.transform(game.moves)

    {:ok, current_player} = ConnectFour.next_player_turn(transformed_moves)

    {x_coordinate, y_coordinate} = ConnectFour.next_slot_in_column(column, transformed_moves)

    {:ok, _move} = App.create_move(%{
      x_coordinate: x_coordinate,
      y_coordinate: y_coordinate,
      player: Atom.to_string(current_player),
      game: game
    })

    game_state = ConnectFour.game_state([
      moves: [{current_player, {x_coordinate, y_coordinate}} | transformed_moves],
      current_player: [player_id: current_player, current_move: {x_coordinate, y_coordinate}],
      config: [connect_what: Game.connect_what, grid_height: Game.grid_height, grid_width: Game.grid_width]
    ])

    {:ok, game} = case game_state do
      {:won, [winner_id: winner_id]} -> App.update_game(game, %{ended: true, winner: Atom.to_string(winner_id)})
      {:draw} -> App.update_game(game, %{ended: true})
        _ -> {:ok, App.get_game!(id)}
    end

    render(conn, "show.json", game: game)
  end
end
