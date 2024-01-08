import React, { useEffect, useState } from "react";
import Grid from "./Grid/Grid";
import { transformGameData } from "../../transformers/transformData";
import { Game } from "../../types/Game";
import getGameId from "../../utils/getGameId";

const baseUrl = "/api/games/";
const Game: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [game, setGame] = useState<Game>();
  const [error, setError] = useState(null);

  useEffect(() => {
    const gameId = getGameId(window.location.pathname);
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
  }, []);

  if (loading) return <div>Loading...</div>;
  if (error) return <div>Apologies! Something went wrong.</div>;

  return (
    <div>
      <Grid
        originalMoves={game!.moves}
        height={game!.gridHeight}
        width={game!.gridWidth}
        gameId={game!.id}
      />
    </div>
  );
};

export default Game;
