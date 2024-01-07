import { Game } from "../types/Game";
import { Move } from "../types/Move";

export const transformGameData = (gameData: Record<string, any>): Game => {
  return {
    id: gameData.id,
    moves: transformMoves(gameData.moves),
    winner: gameData.winner,
    ended: gameData.ended,
    gridHeight: gameData.grid_height,
    gridWidth: gameData.grid_width,
    connectWhat: gameData.connect_what,
  };
};

const transformMoves = (moves: Record<string, any>[]): Move[] => {
  return moves.map((move) => ({
    id: move.id,
    xCoordinate: move.x_coordinate,
    yCoordinate: move.y_coordinate,
    player: move.player,
  }));
};
