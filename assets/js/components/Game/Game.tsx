import React, { useEffect, useState } from "react";
import Grid from "./Grid";

const baseUrl = "/api/games/";
const Game: React.FC = () => {
  const [loading, setLoading] = useState(true);
  const [game, setGame] = useState({});
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch(`${baseUrl}1`)
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        setGame(data);
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
      <Grid />
    </div>
  );
};

export default Game;
