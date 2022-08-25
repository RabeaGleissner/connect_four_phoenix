defmodule ConnectGameWeb.MoveController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Move
  alias ConnectGame.App.Game

  def index(conn, _params) do
    moves = App.list_moves()
    render(conn, "index.html", moves: moves)
  end

  def new(conn, _params) do
    changeset = App.change_move(%Move{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"column" => column, "game_id" => game_id} = params
    game = App.get_game!(game_id)
    transformed_moves = Move.transform(game.moves)

    {:ok, current_player} = ConnectFour.next_player_turn(transformed_moves)

    {x_coordinate, y_coordinate} = ConnectFour.next_slot_in_column(String.to_integer(column), transformed_moves)

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

    case game_state do
      {:won, [winner_id: winner_id]} -> App.update_game(game, %{ended: true, winner: Atom.to_string(winner_id)})
      {:draw} -> App.update_game(game, %{ended: true})
        _ -> {:ok}
    end

    conn
    |> put_flash(:info, "Move created successfully.")
    |> redirect(to: Routes.game_path(conn, :show, game.id))
  end

  def show(conn, %{"id" => id}) do
    move = App.get_move!(id)
    render(conn, "show.html", move: move)
  end

  def edit(conn, %{"id" => id}) do
    move = App.get_move!(id)
    changeset = App.change_move(move)
    render(conn, "edit.html", move: move, changeset: changeset)
  end

  def update(conn, %{"id" => id, "move" => move_params}) do
    move = App.get_move!(id)

    case App.update_move(move, move_params) do
      {:ok, move} ->
        conn
        |> put_flash(:info, "Move updated successfully.")
        |> redirect(to: Routes.move_path(conn, :show, move))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", move: move, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    move = App.get_move!(id)
    {:ok, _move} = App.delete_move(move)

    conn
    |> put_flash(:info, "Move deleted successfully.")
    |> redirect(to: Routes.move_path(conn, :index))
  end
end
