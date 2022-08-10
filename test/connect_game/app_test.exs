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
      assert App.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{ended: true, winner: "some winner"}

      assert {:ok, %Game{} = game} = App.create_game(valid_attrs)
      assert game.ended == true
      assert game.winner == "some winner"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{ended: false, winner: "some updated winner"}

      assert {:ok, %Game{} = game} = App.update_game(game, update_attrs)
      assert game.ended == false
      assert game.winner == "some updated winner"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_game(game, @invalid_attrs)
      assert game == App.get_game!(game.id)
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

    @invalid_attrs %{coordinates: nil, player: nil}

    test "list_moves/0 returns all moves" do
      move = move_fixture()
      assert App.list_moves() == [move]
    end

    test "get_move!/1 returns the move with given id" do
      move = move_fixture()
      assert App.get_move!(move.id) == move
    end

    test "create_move/1 with valid data creates a move" do
      valid_attrs = %{coordinates: "some coordinates", player: "some player"}

      assert {:ok, %Move{} = move} = App.create_move(valid_attrs)
      assert move.coordinates == "some coordinates"
      assert move.player == "some player"
    end

    test "create_move/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = App.create_move(@invalid_attrs)
    end

    test "update_move/2 with valid data updates the move" do
      move = move_fixture()
      update_attrs = %{coordinates: "some updated coordinates", player: "some updated player"}

      assert {:ok, %Move{} = move} = App.update_move(move, update_attrs)
      assert move.coordinates == "some updated coordinates"
      assert move.player == "some updated player"
    end

    test "update_move/2 with invalid data returns error changeset" do
      move = move_fixture()
      assert {:error, %Ecto.Changeset{}} = App.update_move(move, @invalid_attrs)
      assert move == App.get_move!(move.id)
    end

    test "delete_move/1 deletes the move" do
      move = move_fixture()
      assert {:ok, %Move{}} = App.delete_move(move)
      assert_raise Ecto.NoResultsError, fn -> App.get_move!(move.id) end
    end

    test "change_move/1 returns a move changeset" do
      move = move_fixture()
      assert %Ecto.Changeset{} = App.change_move(move)
    end
  end
end
