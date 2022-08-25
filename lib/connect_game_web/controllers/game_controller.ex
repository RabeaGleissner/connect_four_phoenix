defmodule ConnectGameWeb.GameController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Game
  alias ConnectGame.App.Move

  def index(conn, _params) do
    games = App.list_games()
    render(conn, "index.html", games: games)
  end

  def new(conn, _params) do
    changeset = App.change_game(%Game{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, game_params) do
    case App.create_game(game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Blue begins! Drop a coin.")
        |> redirect(to: Routes.game_path(conn, :show, game))
      #{:error, %Ecto.Changeset{} = changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    game = id
          |> App.get_game!()
    last_move = id
                |> App.get_last_move_for_game!

    game_state = case last_move do
      nil -> {:in_progress}
      _ -> ConnectFour.game_state([
          moves: Move.transform(game.moves),
          current_player: [player_id: String.to_atom(last_move.player), current_move: {last_move.x_coordinate, last_move.y_coordinate}],
          config: [connect_what: 4, grid_height: Game.grid_height, grid_width: Game.grid_width]
      ])
    end

    render(conn, "show.html", game: game, grid_width: Game.grid_width, grid_height: Game.grid_height, state: game_state)
  end


  def edit(conn, %{"id" => id}) do
    game = App.get_game!(id)
    changeset = App.change_game(game)
    render(conn, "edit.html", game: game, changeset: changeset)
  end

  def update(conn, %{"id" => id, "game" => game_params}) do
    game = App.get_game!(id)

    case App.update_game(game, game_params) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game updated successfully.")
        |> redirect(to: Routes.game_path(conn, :show, game))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", game: game, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    game = App.get_game!(id)
    {:ok, _game} = App.delete_game(game)

    conn
    |> put_flash(:info, "Game deleted successfully.")
    |> redirect(to: Routes.game_path(conn, :index))
  end
end
