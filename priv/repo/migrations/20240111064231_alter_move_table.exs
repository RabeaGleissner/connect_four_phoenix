defmodule ConnectGame.Repo.Migrations.AlterMoveTable do
  use Ecto.Migration

  def change do
    alter table("moves") do
      remove :coordinates
    end
  end
end
