import React from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Slot from "./Slot";
import Coin from "./Coin";

const Column = ({
  height,
  index,
  columnMoves,
}: {
  height: number;
  index: number;
  columnMoves: Move[];
}) => {
  return (
    <ul>
      {rangeUpTo(height)
        .reverse()
        .map((rowIndex) => (
          <Slot
            data-x-coord={rowIndex}
            data-y-coord={index}
            key={`${rowIndex}${index}`}
          >
            <Coin
              colour={playerToColour(
                columnMoves[rowIndex] && columnMoves[rowIndex].player
              )}
            />
          </Slot>
        ))}
    </ul>
  );
};

const playerToColour = (player: string) => {
  const colours: Record<string, string> = {
    one: "yellow",
    two: "red",
  };
  return colours[player];
};

export default Column;
