import React from "react";
import { Game } from "../../../types/Game";

type GameStateProps = Pick<Game, "winner" | "draw">;

const GameState = ({ winner, draw }: GameStateProps) => {
  return (
    <>
      {winner && <p>Game over! Player "{winner}" wins. </p>}
      {draw && <p>Game over! It's a draw.</p>}
    </>
  );
};

export default GameState;
