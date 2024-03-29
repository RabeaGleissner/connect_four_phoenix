import {
  GameStateReducerState,
  UPDATE_GAME_STATE,
  UpdateGameStatePayload,
  gameStateReducer,
} from "./gameStateReducer";

describe("game state reducer", () => {
  it("updates the game state", () => {
    const initialState: GameStateReducerState = {
      currentPlayer: "red",
      draw: false,
      winner: null,
      ended: false,
    };

    const updatedState: UpdateGameStatePayload = {
      currentPlayer: "yellow",
      draw: false,
      winner: "yellow",
      ended: true,
    };

    const action: UPDATE_GAME_STATE = {
      type: "UPDATE_GAME_STATE",
      payload: updatedState,
    };

    const newState = gameStateReducer(initialState, action);

    expect(newState).toStrictEqual(updatedState);
  });

  it("returns existing state when called with unknown action", () => {
    const initialState: GameStateReducerState = {
      currentPlayer: "red",
      draw: false,
      winner: null,
      ended: false,
    };

    const updatedState: UpdateGameStatePayload = {
      currentPlayer: "yellow",
      draw: false,
      winner: "yellow",
      ended: true,
    };

    const action = {
      type: "UNKNOWN_ACTION",
      payload: updatedState,
    };

    const newState = gameStateReducer(initialState, action as any);

    expect(newState).toStrictEqual(initialState);
  });
});
