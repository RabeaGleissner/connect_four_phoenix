import React, { useState } from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";
import { transformGameData } from "../../../transformers/transformData";
import { baseUrl } from "../../../config";

export interface GridProps {
  originalMoves: Move[];
  width: number;
  height: number;
  gameId: number;
}

const Grid = ({ originalMoves, width, height, gameId }: GridProps) => {
  const [moves, setMoves] = useState<Move[]>(originalMoves);
  const [error, setError] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

  const handleCoinDrop = (colIndex: number) => {
    fetch(`${baseUrl}${gameId}/move`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ column: colIndex }),
    })
      .then((response) => response.json())
      .then((json) => {
        setMoves(transformGameData(json.data).moves);
        setLoading(false);
      })
      .catch((error) => {
        console.error(error);
        setError(error);
      });
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
