import React from "react";
import { useGetGame } from "../../hooks/useGetGame";
import getGameId from "../../utils/getGameId";
import Game from "./Game";

const GameContainer = () => {
  const gameId = getGameId(window.location.pathname);
  const { loading, error, game } = useGetGame(gameId);

  if (error) return <div>Apologies! Something went wrong.</div>;
  if (loading) return <div>Loading...</div>;

  return <Game game={game!} />;
};

export default GameContainer;
