import React, { useState } from "react";
import { Move } from "../../../types/Move";
import rangeUpTo from "../../../utils/rangeUpTo";
import Column from "./Colum";
import { transformGameData } from "../../../transformers/transformData";
import { baseUrl } from "../../../config";
import { Game } from "../../../types/Game";
import CoinDropButton from "./CoinDropButton";

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

  const isCoinDropDisabled = (colIndex: number): boolean =>
    loading || ended || isColumnFull(colIndex);

  const isColumnFull = (colIndex: number) =>
    movesForColumn(colIndex).length >= gridHeight;

  const movesForColumn = (columnIndex: number) =>
    moves.filter((move) => move.yCoordinate === columnIndex);

  return (
    <>
      <div className="h-5">
        {error && (
          <p className="text-red-500 ">
            ️😱 an error happened during your coin drop
          </p>
        )}
        {!ended && <p>Please choose a column to drop a coin</p>}
      </div>
      <div className="flex mt-5">
        {rangeUpTo(gridWidth).map((colIndex) => (
          <div key={colIndex}>
            <div className="mb-2">
              <CoinDropButton
                handleCoinDrop={() => handleCoinDrop(colIndex)}
                isDisabled={isCoinDropDisabled(colIndex)}
              />
            </div>
            <Column
              height={gridHeight}
              index={colIndex}
              columnMoves={movesForColumn(colIndex)}
            />
          </div>
        ))}
      </div>
    </>
  );
};

export default Grid;
