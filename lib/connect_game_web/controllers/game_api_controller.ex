defmodule ConnectGameWeb.GameApiController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Rules
  alias ConnectGame.App.Game
  alias ConnectGame.App.AiPlayer
  alias ConnectGameWeb.Helpers.RandomNumber

  def show(conn, %{"id" => id}) do
    game = App.get_game_for_view!(id)

    render(conn, "show.json", game: game)
  end

  def create_move(conn, params) do
    %{"column" => column, "id" => id} = params
    create_move(id, column, conn)
  end

  def create_ai_move(conn, params) do
    %{"id" => id} = params
    game = App.get_game!(id)

    column =
      AiPlayer.choose_column(game.moves, Game.grid_height(), &RandomNumber.generate_between/2)

    create_move(id, column, conn)
  end

  defp create_move(game_id, column, conn) do
    game = App.get_game!(game_id)

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

      game = App.get_game_for_view!(game_id)

      render(conn, "show.json", game: game)
    end
  end

  defp game_config do
    [
      connect_what: Game.connect_what(),
      grid_height: Game.grid_height(),
      grid_width: Game.grid_width()
    ]
  end
end
