import React, { useState } from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";
import { transformGameData } from "../../../transformers/transformData";
import { baseUrl } from "../../../config";
import { Game } from "../../../types/Game";

export type GridProps = Pick<Game, "gridWidth" | "gridHeight" | "ended"> & {
  gameId: Game["id"];
  originalMoves: Game["moves"];
  setGame: (game: any) => void;
};

const Grid = ({
  originalMoves,
  gridWidth,
  gridHeight,
  gameId,
  ended,
  setGame,
}: GridProps) => {
  const [moves, setMoves] = useState<Move[]>(originalMoves);
  const [error, setError] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

  const handleCoinDrop = (colIndex: number) => {
    setLoading(true);
    fetch(`${baseUrl}${gameId}/move`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ column: colIndex }),
    })
      .then((response) => response.json())
      .then((json) => {
        const game = transformGameData(json.data);
        setMoves(game.moves);
        setGame(game);
        setLoading(false);
      })
      .catch((error) => {
        console.error(error);
        setError(error);
      });
  };

  const coinDropDisalbed = loading || ended;

  return (
    <>
      <div className="h-5">
        {error ? (
          <p className="text-red-500 ">
            ️😱 an error happened during your coin drop
          </p>
        ) : (
          <p>Please choose a column to drop a coin</p>
        )}
      </div>
      <div className="flex mt-5">
        {rangeUpTo(gridWidth).map((colIndex) => (
          <div key={colIndex}>
            <div className="mb-2">
              <button
                aria-label="Drop coin in column"
                onClick={() => handleCoinDrop(colIndex)}
                className={`cursor-pointer w-20 h-10 bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-2 border border-gray-400 rounded shadow ${
                  coinDropDisalbed && "cursor-not-allowed"
                }`}
                disabled={coinDropDisalbed}
              >
                <p className="text-xl">👇</p>️
              </button>
            </div>
            <Column
              height={gridHeight}
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
