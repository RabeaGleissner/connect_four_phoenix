defmodule ConnectGame.AppTest do
  use ConnectGame.DataCase

  alias ConnectGame.App

  describe "games" do
    alias ConnectGame.App.Game

    import ConnectGame.AppFixtures

    @invalid_attrs %{ended: nil, winner: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert App.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      game_result = App.get_game!(game.id)
      assert game_result.ended == game.ended
      assert game_result.winner == game.winner
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{ended: true, winner: "some winner"}

      assert {:ok, %Game{} = game} = App.create_game(valid_attrs)
      assert game.ended == true
      assert game.winner == "some winner"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_game(%{ended: "something", winner: 3})
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = App.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> App.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = App.change_game(game)
    end
  end

  describe "moves" do
    alias ConnectGame.App.Move

    import ConnectGame.AppFixtures

    @invalid_attrs %{player: nil}

    test "list_moves/0 returns all moves" do
      game = game_fixture()
      move = move_fixture(%{game: game})

      first_move = App.list_moves() |> List.first

      assert first_move.game_id == move.game_id
      assert first_move.player == move.player
    end

    test "get_move!/1 returns the move with given id" do
      move = move_fixture()

      move_result = App.get_move!(move.id)

      assert move_result.player == move.player
    end

    test "get_last_move_for_game!/1 returns the last inserted move for a game" do
      game = game_fixture()
      move_fixture(%{game: game, player: "one"})
      :timer.sleep(1000)
      move_fixture(%{game: game, player: "two"})
      :timer.sleep(1000)
      move_3 = move_fixture(%{game: game, player: "three"})

      move_result = App.get_last_move_for_game!(game.id)

      assert move_result.player == move_3.player
    end

    test "create_move/1 with valid data creates a move" do
      valid_attrs = %{player: "some player", x_coordinate: 1, y_coordinate: 1}

      assert {:ok, %Move{} = move} = App.create_move(valid_attrs)
      assert move.x_coordinate == 1
      assert move.y_coordinate == 1
      assert move.player == "some player"
    end

    test "create_move/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_move(@invalid_attrs)
    end

    test "change_move/1 returns a move changeset" do
      move = move_fixture()
      assert %Ecto.Changeset{} = App.change_move(move)
    end
  end
end
