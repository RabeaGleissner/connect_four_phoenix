defmodule ConnectGame.App.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :ended, :boolean, default: false
    field :winner, :string
    has_many :moves, ConnectGame.App.Move

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:winner, :ended])
    |> validate_required([:ended])
  end
end
