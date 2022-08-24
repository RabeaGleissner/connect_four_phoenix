defmodule ConnectGame.AppFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ConnectGame.App` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        ended: false,
        winner: nil
      })
      |> ConnectGame.App.create_game()

    game
  end

  @doc """
  Generate a move.
  """
  def move_fixture(attrs \\ %{}) do
    {:ok, move} =
      attrs
      |> Enum.into(%{
        x_coordinate: 0,
        y_coordinate: 0,
        coordinates: :erlang.term_to_binary({0,0}),
        player: Atom.to_string(:one)
      })
      |> ConnectGame.App.create_move()

    move
  end
end
