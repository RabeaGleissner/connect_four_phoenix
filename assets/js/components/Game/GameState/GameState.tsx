import React from "react";
import { Game } from "../../../types/Game";
import Coin from "../Grid/Coin";

type GameStateProps = Pick<Game, "winner" | "draw" | "ended"> & {
  currentPlayer?: Player;
};

const GameState = ({ ended, winner, draw, currentPlayer }: GameStateProps) => {
  return (
    <>
      {winner && <p>✨ Game over! Player "{winner}" wins. 🏆</p>}
      {draw && <p>✨ Game over! It's a draw. ✨</p>}
      {!ended && currentPlayer && (
        <div className="flex">
          <p>Next player: {currentPlayer}</p>
          <Coin small colour={currentPlayer} />
        </div>
      )}
    </>
  );
};

export default GameState;
