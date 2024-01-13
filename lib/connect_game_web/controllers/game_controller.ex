defmodule ConnectGameWeb.GameController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Game
  alias ConnectGame.App.Rules

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
    game = get_game_for_view(id)

    render(conn, "show.html",
      game: game,
      grid_width: Game.grid_width(),
      grid_height: Game.grid_height()
    )
  end

  def show_api(conn, %{"id" => id}) do
    game = get_game_for_view(id)

    render(conn, "show.json", game: game)
  end

  def create_move_api(conn, params) do
    %{"column" => column, "id" => id} = params
    game = App.get_game!(id)

    if game.ended do
      conn
      |> put_status(400)
      |> put_view(ConnectGameWeb.ErrorView)
      |> render("move_creation_error.json", %{message: "Game over! Not allowed to create a move."})
      |> Plug.Conn.halt()
    else
      {:ok,
       %{
         coordinates: {x_coordinate, y_coordinate},
         current_player: current_player,
         game_state: game_state
       }} = Rules.handle_move(game, column, game_config())

      {:ok, _move} =
        App.create_move(%{
          x_coordinate: x_coordinate,
          y_coordinate: y_coordinate,
          player: Atom.to_string(current_player),
          game: game
        })

      case game_state do
        {:won, [winner_id: winner_id]} ->
          App.update_game(game, %{ended: true, winner: Atom.to_string(winner_id)})

        {:draw} ->
          App.update_game(game, %{ended: true})

        _ ->
          true
      end

      game = get_game_for_view(id)

      render(conn, "show.json", game: game)
    end
  end

  defp get_game_for_view(id) do
    game =
      id
      |> App.get_game!()

    game_with_extra_information =
      struct(game, %{
        draw: Rules.is_drawn?(game),
        current_player: Rules.current_player(game.moves)
      })

    game_with_extra_information
  end

  defp game_config do
    [
      connect_what: Game.connect_what(),
      grid_height: Game.grid_height(),
      grid_width: Game.grid_width()
    ]
  end
end
