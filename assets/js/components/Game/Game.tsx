import React, { useEffect, useState } from "react";
import Grid from "./Grid/Grid";
import GameState from "./GameState/GameState";
import { Game } from "../../types/Game";

interface GameProps {
  game: Game;
}

const Game = ({ game }: GameProps) => {
  const [gameEnded, setGameEnded] = useState<boolean>(game.ended);
  const [winner, setWinner] = useState<Player | null>(game.winner);
  const [draw, setDraw] = useState(game.draw);
  const [currentPlayer, setCurrentPlayer] = useState(game.currentPlayer);

  return (
    <>
      <GameState
        ended={gameEnded}
        winner={winner}
        draw={draw}
        currentPlayer={currentPlayer}
      />
      <Grid
        originalMoves={game!.moves}
        gridHeight={game!.gridHeight}
        gridWidth={game!.gridWidth}
        setGameEnded={setGameEnded}
        setWinner={setWinner}
        setDraw={setDraw}
        setCurrentPlayer={setCurrentPlayer}
        gameId={game!.id}
        ended={gameEnded}
      />
    </>
  );
};

export default Game;
