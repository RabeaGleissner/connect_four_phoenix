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

  def transform_coordinates(game) do
    {moves, rest} = Map.pop(game, :moves)
    coordinates = Enum.map(moves, fn move ->
      move.coordinates
      |> :erlang.binary_to_term()
    end)
    %{moves: coordinates, winner: rest.winner, id: rest.id, ended: rest.ended}
  end
end
