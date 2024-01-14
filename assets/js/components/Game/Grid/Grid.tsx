import React, { useMemo, useState } from "react";
import { Move } from "../../../types/Move";
import { Game } from "../../../types/Game";
import { baseUrl } from "../../../config";
import rangeUpTo from "../../../utils/rangeUpTo";
import { transformGameData } from "../../../transformers/transformData";
import Column from "./Colum";
import CoinDropButton from "./CoinDropButton";

export type GridProps = Pick<Game, "gridWidth" | "gridHeight" | "ended"> & {
  gameId: Game["id"];
  originalMoves: Game["moves"];
  setGameEnded: (ended: boolean) => void;
  setWinner: (player: Player) => void;
  setDraw: (draw: boolean) => void;
  setCurrentPlayer: (player: Player) => void;
};

const Grid = ({
  originalMoves,
  gridWidth,
  gridHeight,
  gameId,
  ended,
  setGameEnded,
  setDraw,
  setWinner,
  setCurrentPlayer,
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
        setGameEnded(game.ended);
        setDraw(game.draw);
        setCurrentPlayer(game.currentPlayer);
        if (game.winner) {
          setWinner(game.winner);
        }
        setLoading(false);
      })
      .catch((error) => {
        console.error(error);
        setError(error);
      });
  };

  const columns = useMemo<number[]>(() => rangeUpTo(gridWidth), [gridWidth]);
  const slotsForColumn = useMemo<number[]>(
    () => rangeUpTo(gridHeight).reverse(),
    [gridHeight]
  );

  const movesForColumn = (columnIndex: number) =>
    moves.filter((move) => move.yCoordinate === columnIndex);

  const isCoinDropDisabled = (colIndex: number): boolean =>
    ended || movesForColumn(colIndex).length >= gridHeight;

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
        {columns.map((colIndex) => (
          <div key={colIndex}>
            <div className="mb-2">
              <CoinDropButton
                handleCoinDrop={() => handleCoinDrop(colIndex)}
                isDisabled={isCoinDropDisabled(colIndex)}
                loading={loading}
              />
            </div>
            <Column
              slots={slotsForColumn}
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
