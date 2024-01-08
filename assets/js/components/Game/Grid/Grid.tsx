import React, { useState } from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";
import { useMakeMove } from "../../../hooks/useMakeMove";

export interface GridProps {
  originalMoves: Move[];
  width: number;
  height: number;
  gameId: number;
}

const Grid = ({ originalMoves, width, height, gameId }: GridProps) => {
  const [moves, setMoves] = useState<Move[]>(originalMoves);
  const [error, setError] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(true);

  const handleCoinDrop = (colIndex: number) => {
    const { moves, error, loading } = useMakeMove(gameId, colIndex);
    setError(error);
    setLoading(loading);
    if (moves) {
      setMoves(moves);
    }
  };

  return (
    <>
      {error && (
        <p className="text-red-500 mb-10">
          ️😱 an error happened during your coin drop
        </p>
      )}
      <div className="flex">
        {rangeUpTo(width).map((colIndex) => (
          <div key={colIndex}>
            <button
              onClick={() => handleCoinDrop(colIndex)}
              className="w-20 h-10"
              disabled={loading}
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
    </>
  );
};

const movesForColumn = (moves: Move[], columnIndex: number) => {
  return moves.filter((move) => move.yCoordinate === columnIndex);
};

export default Grid;
