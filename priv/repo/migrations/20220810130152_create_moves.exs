defmodule ConnectGame.Repo.Migrations.CreateMoves do
  use Ecto.Migration

  def change do
    create table(:moves) do
      add :player, :string
      add :coordinates, :binary
      add :game_id, references(:games, on_delete: :nothing)

      timestamps()
    end

    create index(:moves, [:game_id])
  end
end
