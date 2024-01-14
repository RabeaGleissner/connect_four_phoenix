import React, { useEffect, useState } from "react";
import Grid from "./Grid/Grid";
import getGameId from "../../utils/getGameId";
import { useGetGame } from "../../hooks/useGetGame";
import GameState from "./GameState/GameState";
import { Game } from "../../types/Game";

const Game = () => {
  const gameId = getGameId(window.location.pathname);
  const { loading, error, game } = useGetGame(gameId);
  const [gameEnded, setGameEnded] = useState<boolean>(false);
  const [winner, setWinner] = useState<Player | null>(null);
  const [draw, setDraw] = useState(false);

  console.log("game", game);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Apologies! Something went wrong.</div>;

  if (game) {
    return (
      <>
        <div className="h-10">
          <GameState
            ended={gameEnded}
            winner={winner}
            draw={draw}
            currentPlayer={game!.currentPlayer}
          />
        </div>
        <Grid
          originalMoves={game!.moves}
          gridHeight={game!.gridHeight}
          gridWidth={game!.gridWidth}
          setGameEnded={setGameEnded}
          setWinner={setWinner}
          setDraw={setDraw}
          gameId={game!.id}
          ended={gameEnded}
        />
      </>
    );
  }
};

export default Game;
