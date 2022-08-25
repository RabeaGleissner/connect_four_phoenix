defmodule ConnectGame.App.Game do
  use Ecto.Schema
  import Ecto.Changeset

  @grid_height 6
  @grid_width 7

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

  def grid_width, do: @grid_width
  def grid_height, do: @grid_height
end
