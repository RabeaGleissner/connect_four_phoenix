defmodule ConnectGame.App do
  alias ConnectGame.App.Rules
  alias ConnectGame.App.Game

  @moduledoc """
  The App context.
  """

  import Ecto.Query, warn: false
  alias ConnectGame.Repo

  alias ConnectGame.App.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id) do
    Repo.get!(Game, id)
    |> Repo.preload(:moves)
  end

  @doc """
  Gets a single game including the virtual fields on the Game struct.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game_for_view!(123)
      %Game{}

      iex> get_game_for_view!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_for_view!(id) do
    game =
      id
      |> get_game!()

    game_with_virtual_fields =
      struct(game, %{
        draw: Rules.is_drawn?(game),
        current_player: Rules.current_player(game.moves)
      })

    game_with_virtual_fields
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  alias ConnectGame.App.Move

  @doc """
  Returns the list of moves.

  ## Examples

      iex> list_moves()
      [%Move{}, ...]

  """
  def list_moves do
    Repo.all(Move)
  end

  @doc """
  Gets a single move.

  Raises `Ecto.NoResultsError` if the Move does not exist.

  ## Examples

      iex> get_move!(123)
      %Move{}

      iex> get_move!(456)
      ** (Ecto.NoResultsError)

  """
  def get_move!(id), do: Repo.get!(Move, id)

  @doc """
  Gets the most recent move for a game

  Raises `Ecto.NoResultsError` if the Move does not exist.

  ## Examples

      iex> get_last_move_for_game!(123)
      %Move{}

      iex> get_last_move_for_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_last_move_for_game!(game_id) do
    Move |> where(game_id: ^game_id) |> last(:inserted_at) |> Repo.one()
  end

  @doc """
  Creates a move.

  ## Examples

      iex> create_move(%{field: value})
      {:ok, %Move{}}

      iex> create_move(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_move(attrs \\ %{}) do
    {game, move_attrs} = Map.pop(attrs, :game)

    %Move{}
    |> Move.changeset(move_attrs)
    |> Ecto.Changeset.put_assoc(:game, game)
    |> Repo.insert()
  end

  @doc """
  Deletes a move.

  ## Examples

      iex> delete_move(move)
      {:ok, %Move{}}

      iex> delete_move(move)
      {:error, %Ecto.Changeset{}}

  """
  def delete_move(%Move{} = move) do
    Repo.delete(move)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking move changes.

  ## Examples

      iex> change_move(move)
      %Ecto.Changeset{data: %Move{}}

  """
  def change_move(%Move{} = move, attrs \\ %{}) do
    Move.changeset(move, attrs)
  end
end
