export type ApiPlayer = "one" | "two";

export interface ApiMove {
  id: number;
  x_coordinate: number;
  y_coordinate: number;
  player: ApiPlayer;
}

export interface ApiGame {
  ended: boolean;
  id: number;
  winner: ApiPlayer | null;
  grid_height: number;
  grid_width: number;
  connect_what: number;
  draw: boolean;
  current_player: ApiPlayer;
  moves: ApiMove[];
}
