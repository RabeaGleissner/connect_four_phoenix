import { Game } from "../types/Game";

export type UpdateGameStatePayload = {
  winner: Player | null;
  draw: boolean;
  ended: boolean;
  currentPlayer: Player;
};

export type UPDATE_GAME_STATE = {
  type: "UPDATE_GAME_STATE";
  payload: UpdateGameStatePayload;
};

export type GameStateReducerState = Pick<
  Game,
  "currentPlayer" | "draw" | "ended" | "winner"
>;

export type ACTIONS = UPDATE_GAME_STATE;

export const gameStateReducer = (
  state: GameStateReducerState,
  action: ACTIONS
) => {
  switch (action.type) {
    case "UPDATE_GAME_STATE": {
      return {
        ...state,
        ...action.payload,
      };
    }
    default: {
      return state;
    }
  }
};
