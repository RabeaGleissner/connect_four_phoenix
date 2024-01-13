import React, { useEffect, useState } from "react";
import Grid from "./Grid/Grid";
import getGameId from "../../utils/getGameId";
import { useGetGame } from "../../hooks/useGetGame";
import GameState from "./GameState/GameState";
import { Game } from "../../types/Game";

const Game = () => {
  const gameId = getGameId(window.location.pathname);
  const [game, setGame] = useState<Game>();
  const { loading, error } = useGetGame(gameId, setGame);
  console.log("game", game);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Apologies! Something went wrong.</div>;

  return (
    <>
      <div className="h-10">
        <GameState
          winner={game!.winner}
          draw={game!.draw}
          currentPlayer={game!.currentPlayer}
        />
      </div>
      <Grid
        originalMoves={game!.moves}
        gridHeight={game!.gridHeight}
        gridWidth={game!.gridWidth}
        setGame={setGame}
        gameId={game!.id}
        ended={game!.ended}
      />
    </>
  );
};

export default Game;
