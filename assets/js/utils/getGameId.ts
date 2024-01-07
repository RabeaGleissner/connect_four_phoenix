const getGameId = (pathname: string): string => {
  const gameId = pathname.split("/").pop();
  return gameId || "";
};

export default getGameId;
