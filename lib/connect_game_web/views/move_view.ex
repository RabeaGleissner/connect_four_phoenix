defmodule ConnectGameWeb.MoveView do
  use ConnectGameWeb, :view

  def render("move.json", %{move: move}) do
    %{
      id: move.id,
      x_coordinate: move.x_coordinate,
      y_coordinate: move.y_coordinate,
      player: move.player,
      coordinates: move.coordinates
    }
  end
end
