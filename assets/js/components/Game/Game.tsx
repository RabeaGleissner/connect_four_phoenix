import React from "react";
import Grid from "./Grid/Grid";
import { Game } from "../../types/Game";
import getGameId from "../../utils/getGameId";
import { useGetGame } from "../../hooks/useGetGame";

const Game: React.FC = () => {
  const gameId = getGameId(window.location.pathname);

  const { game, error, loading } = useGetGame(gameId);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Apologies! Something went wrong.</div>;

  return (
    <Grid
      originalMoves={game!.moves}
      height={game!.gridHeight}
      width={game!.gridWidth}
      gameId={game!.id}
    />
  );
};

export default Game;
