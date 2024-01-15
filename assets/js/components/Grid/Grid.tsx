import React, { Dispatch, useMemo, useState } from "react";
import { Move } from "../../types/Move";
import { Game } from "../../types/Game";
import { baseUrl } from "../../config";
import rangeUpTo from "../../utils/rangeUpTo";
import { transformGameData } from "../../transformers/transformData";
import Column from "./Colum";
import CoinDropButton from "./CoinDropButton";
import request from "../../utils/request";
import { UPDATE_GAME_STATE } from "../../reducers/gameStateReducer";

export type GridProps = Pick<Game, "gridWidth" | "gridHeight" | "ended"> & {
  gameId: Game["id"];
  originalMoves: Game["moves"];
  dispatch: Dispatch<UPDATE_GAME_STATE>;
};

const Grid = ({
  originalMoves,
  gridWidth,
  gridHeight,
  gameId,
  ended,
  dispatch,
}: GridProps) => {
  const [moves, setMoves] = useState<Move[]>(originalMoves);
  const [error, setError] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);

  const handleCoinDrop = (colIndex: number) => {
    request({
      url: `${baseUrl}${gameId}/move`,
      requestBody: { column: colIndex },
      handleResponse: (data) => {
        const { moves, ended, draw, currentPlayer, winner } =
          transformGameData(data);
        setMoves(moves);
        dispatch({
          type: "UPDATE_GAME_STATE",
          payload: {
            winner: winner && winner,
            currentPlayer,
            ended,
            draw,
          },
        });
      },
      setLoading,
      setError,
    });
  };

  const columns = useMemo<number[]>(() => rangeUpTo(gridWidth), [gridWidth]);
  const slotsForColumn = useMemo<number[]>(
    () => rangeUpTo(gridHeight).reverse(),
    [gridHeight]
  );

  const movesForColumn = (columnIndex: number) =>
    moves.filter(({ yCoordinate }) => yCoordinate === columnIndex);

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
