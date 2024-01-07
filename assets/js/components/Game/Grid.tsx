import React from "react";
import { Move } from "../../types/Move";

interface GridProps {
  moves: Move[];
  width: number;
  height: number;
}

const Grid = ({ moves, width, height }: GridProps) => {
  return (
    <div className="flex">
      {rangeUpTo(width).map((colIndex) => (
        <div key={colIndex}>
          <Column
            height={height}
            index={colIndex}
            columnMoves={movesForColumn(moves, colIndex)}
          />
        </div>
      ))}
    </div>
  );
};

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
            colour={
              columnMoves[rowIndex] &&
              playerToColour(columnMoves[rowIndex].player)
            }
          />
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

const Slot = ({ colour }: { colour?: string }) => {
  return (
    <li className="block bg-blue-900 border-solid border-1 border-blue-900 w-20 h-20">
      <Coin colour={colour} />
    </li>
  );
};

const Coin = ({ colour }: { colour?: string }) => {
  const backgroundColour = colour ? `bg-${colour}-500` : "bg-white";
  return (
    <div className={`block w-16 h-16 ${backgroundColour} rounded-full ml-2`}>
      &nbsp;
    </div>
  );
};

const rangeUpTo = (n: number) => [...Array(n).keys()];

const movesForColumn = (moves: Move[], columnIndex: number) => {
  return moves.filter((move) => move.xCoordinate === columnIndex);
};

export default Grid;
