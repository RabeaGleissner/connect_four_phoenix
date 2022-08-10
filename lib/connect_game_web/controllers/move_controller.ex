defmodule ConnectGameWeb.MoveController do
  use ConnectGameWeb, :controller

  alias ConnectGame.App
  alias ConnectGame.App.Move

  def index(conn, _params) do
    moves = App.list_moves()
    render(conn, "index.html", moves: moves)
  end

  def new(conn, _params) do
    changeset = App.change_move(%Move{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"move" => move_params}) do
    case App.create_move(move_params) do
      {:ok, move} ->
        conn
        |> put_flash(:info, "Move created successfully.")
        |> redirect(to: Routes.move_path(conn, :show, move))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
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