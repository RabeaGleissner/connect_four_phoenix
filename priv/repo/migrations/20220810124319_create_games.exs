defmodule ConnectGame.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :winner, :string
      add :ended, :boolean, default: false, null: false

      timestamps()
    end
  end
end
