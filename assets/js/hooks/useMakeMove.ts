import React, { useState } from "react";
import { transformGameData } from "../transformers/transformData";
import { baseUrl } from "../config";
import { Move } from "../types/Move";

export const useMakeMove = (gameId: number, columnIndex: number) => {
  const [loading, setLoading] = useState<boolean>(true);
  const [moves, setMoves] = useState<Move[]>();
  const [error, setError] = useState<boolean>(false);

  fetch(`${baseUrl}${gameId}/move`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ column: columnIndex }),
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

  return { moves, error, loading };
};
