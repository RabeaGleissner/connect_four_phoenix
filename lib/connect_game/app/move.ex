defmodule ConnectGame.App.Move do
  use Ecto.Schema
  import Ecto.Changeset

  schema "moves" do
    field :coordinates, :binary
    field :x_coordinate, :integer
    field :y_coordinate, :integer
    field :player, :string
    belongs_to :game, ConnectGame.App.Game, foreign_key: :game_id


    timestamps()
  end

  @doc false
  def changeset(move, attrs) do
    move
    |> cast(attrs, [:player, :coordinates, :x_coordinate, :y_coordinate])
    |> validate_required([:player, :coordinates, :x_coordinate, :y_coordinate])
  end
end
