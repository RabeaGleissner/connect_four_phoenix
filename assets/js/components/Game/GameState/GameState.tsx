import React from "react";
import { Game } from "../../../types/Game";
import Coin from "../Grid/Coin";

type GameStateProps = Pick<Game, "winner" | "draw"> & {
  currentPlayer?: Player;
};

const GameState = ({ winner, draw, currentPlayer }: GameStateProps) => {
  const gameOver = winner || draw;
  return (
    <>
      {winner && <p>Game over! Player "{winner}" wins. </p>}
      {draw && <p>Game over! It's a draw.</p>}
      {!gameOver && currentPlayer && (
        <div className="flex">
          <p>Next player: {currentPlayer}</p>
          <Coin small colour={currentPlayer} />
        </div>
      )}
    </>
  );
};

export default GameState;
