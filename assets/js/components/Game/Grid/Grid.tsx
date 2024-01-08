import React, { useEffect, useState } from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";
import { transformGameData } from "../../../transformers/transformData";

interface GridProps {
  originalMoves: Move[];
  width: number;
  height: number;
}

const Grid = ({ originalMoves, width, height }: GridProps) => {
  const [moves, setMoves] = useState<Move[]>(originalMoves);

  const handleCoinDrop = (colIndex: number) => {
    fetch("/api/games/6/move", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ column: colIndex }),
    })
      .then((response) => response.json())
      .then((json) => {
        setMoves(transformGameData(json.data).moves);
      });
  };

  return (
    <div className="flex">
      {rangeUpTo(width).map((colIndex) => (
        <div key={colIndex}>
          <button
            onClick={() => handleCoinDrop(colIndex)}
            className="w-20 h-10"
          >
            <p className="text-xl">⬇</p>️
          </button>
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
  return moves.filter((move) => move.yCoordinate === columnIndex);
};

export default Grid;
