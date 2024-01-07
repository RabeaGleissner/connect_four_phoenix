import React, { useEffect, useState } from "react";
import Grid from "./Grid";
import { transformGameData } from "../../transformers/transformData";
import { Game } from "../../types/Game";

const baseUrl = "/api/games/";
const Game: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [game, setGame] = useState<Game>();
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${baseUrl}1`)
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
  if (error)
    return <div>Apologies! Something went wrong. Please reload the page.</div>;

  return (
    <div>
      <Grid
        moves={game!.moves}
        height={game!.gridHeight}
        width={game!.gridWidth}
      />
    </div>
  );
};

export default Game;
