import { Move } from "./Move";

export interface Game {
  id: number;
  moves: Move[];
  winner: Player | null;
  ended: boolean;
  gridHeight: number;
  gridWidth: number;
  connectWhat: number;
  draw: boolean;
  currentPlayer: Player;
}
