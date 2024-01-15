import React, { useEffect, useState } from "react";
import { Game } from "../types/Game";
import { transformGameData } from "../transformers/transformData";
import { baseUrl } from "../config";
import request from "../utils/request";

export const useGetGame = (
  gameId: string
): { game?: Game; error: boolean; loading: boolean } => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<boolean>(false);
  const [game, setGame] = useState<Game>();

  useEffect(() => {
    request({
      url: `${baseUrl}${gameId}`,
      handleResponse: (data) => {
        setGame(transformGameData(data));
      },
      setError,
      setLoading,
    });
  }, [gameId]);

  return { error, loading, game };
};
