defmodule ConnectGame.App.Move do
  use Ecto.Schema
  import Ecto.Changeset

  schema "moves" do
    field :coordinates, :binary
    field :player, :string
    belongs_to :game, ConnectGame.App.Game, foreign_key: :game_id


    timestamps()
  end

  @doc false
  def changeset(move, attrs) do
    move
    |> cast(attrs, [:player, :coordinates])
    |> validate_required([:player, :coordinates])
  end
end
