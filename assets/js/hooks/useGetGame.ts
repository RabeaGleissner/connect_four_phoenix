import React, { useEffect, useState } from "react";
import { Game } from "../types/Game";
import { transformGameData } from "../transformers/transformData";
import { baseUrl } from "../config";

export const useGetGame = (
  gameId: string
): { game?: Game; error: boolean; loading: boolean } => {
  const [loading, setLoading] = useState<boolean>(true);
  const [game, setGame] = useState<Game>();
  const [error, setError] = useState<boolean>(false);

  useEffect(() => {
    fetch(`${baseUrl}${gameId}`)
      .then((response) => response.json())
      .then((json) => {
        setGame(transformGameData(json.data));
        setLoading(false);
      })
      .catch((error) => {
        console.error(error);
        setError(error);
      });
  }, [gameId]);

  return { game, error, loading };
};
