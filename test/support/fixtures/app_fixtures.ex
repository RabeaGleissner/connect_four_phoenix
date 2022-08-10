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
        ended: true,
        winner: "some winner"
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
        coordinates: "some coordinates",
        player: "some player"
      })
      |> ConnectGame.App.create_move()

    move
  end
end
