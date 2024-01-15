import React, { useReducer } from "react";
import Grid from "../Grid/Grid";
import GameState from "../GameState/GameState";
import { Game } from "../../types/Game";
import { gameStateReducer } from "../../reducers/gameStateReducer";

interface GameProps {
  game: Game;
}

const Game = ({ game: initialGame }: GameProps) => {
  const initialState = {
    ended: initialGame.ended,
    draw: initialGame.draw,
    winner: initialGame.winner,
    currentPlayer: initialGame.currentPlayer,
  };

  const [gameState, dispatch] = useReducer(gameStateReducer, initialState);

  return (
    <>
      <GameState
        ended={gameState.ended}
        winner={gameState.winner}
        draw={gameState.draw}
        currentPlayer={gameState.currentPlayer}
      />
      <Grid
        originalMoves={initialGame!.moves}
        gridHeight={initialGame!.gridHeight}
        gridWidth={initialGame!.gridWidth}
        gameId={initialGame!.id}
        ended={gameState.ended}
        dispatch={dispatch}
      />
    </>
  );
};

export default Game;
