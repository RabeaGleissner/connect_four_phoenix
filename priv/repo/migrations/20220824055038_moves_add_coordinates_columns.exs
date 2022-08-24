defmodule ConnectGame.Repo.Migrations.MovesAddCoordinatesColumns do
  use Ecto.Migration

  def change do
    alter table("moves") do
      add :x_coordinate, :integer
      add :y_coordinate, :integer
    end
  end
end
