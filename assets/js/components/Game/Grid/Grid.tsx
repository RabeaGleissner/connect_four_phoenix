import React from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";

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

const movesForColumn = (moves: Move[], columnIndex: number) => {
  return moves.filter((move) => move.xCoordinate === columnIndex);
};

export default Grid;
