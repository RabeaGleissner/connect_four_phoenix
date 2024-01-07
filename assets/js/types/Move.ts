export interface Move {
  id: number;
  xCoordinate: number;
  yCoordinate: number;
  player: string;
  coordinates?: any; // will be removed
}
