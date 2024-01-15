import { Game } from "../types/Game";
import { Move } from "../types/Move";
import { ApiGame, ApiMove, ApiPlayer } from "../types/api/ApiTypes";

export const transformGameData = (gameData: ApiGame): Game => ({
  id: gameData.id,
  moves: transformMoves(gameData.moves),
  winner: gameData.winner
    ? transformPlayerToColour(gameData.winner)
    : gameData.winner,
  ended: gameData.ended,
  gridHeight: gameData.grid_height,
  gridWidth: gameData.grid_width,
  connectWhat: gameData.connect_what,
  draw: gameData.draw,
  currentPlayer: transformPlayerToColour(gameData.current_player),
});

const transformMoves = (moves: ApiMove[]): Move[] =>
  moves.map((move) => ({
    id: move.id,
    xCoordinate: move.x_coordinate,
    yCoordinate: move.y_coordinate,
    player: transformPlayerToColour(move.player),
  }));

const transformPlayerToColour = (player: ApiPlayer): Player => {
  const colours: Record<ApiPlayer, Player> = {
    one: "yellow",
    two: "red",
  };
  return colours[player];
};
