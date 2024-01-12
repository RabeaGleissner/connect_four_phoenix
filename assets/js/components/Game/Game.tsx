import React from "react";
import Grid from "./Grid/Grid";
import getGameId from "../../utils/getGameId";
import { useGetGame } from "../../hooks/useGetGame";
import GameState from "./GameState/GameState";

const Game = () => {
  const gameId = getGameId(window.location.pathname);

  const { game, error, loading } = useGetGame(gameId);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Apologies! Something went wrong.</div>;

  return (
    <>
      <GameState winner={game!.winner} draw={game!.draw} />
      <Grid
        originalMoves={game!.moves}
        gridHeight={game!.gridHeight}
        gridWidth={game!.gridWidth}
        gameId={game!.id}
        ended={game!.ended}
      />
    </>
  );
};

export default Game;
