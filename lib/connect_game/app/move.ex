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
    |> cast(attrs, [:player, :x_coordinate, :y_coordinate])
    |> validate_required([:player, :x_coordinate, :y_coordinate])
  end

  def transform(moves) do
    Enum.map(moves, fn %{player: player, x_coordinate: x_coordinate, y_coordinate: y_coordinate} ->
      {String.to_atom(player), {x_coordinate, y_coordinate}}
    end)
  end
end
