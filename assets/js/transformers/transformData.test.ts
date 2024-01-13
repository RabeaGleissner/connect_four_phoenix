import { transformGameData } from "./transformData";

describe("transform data for the UI", () => {
  it("transforms initial game data from API", () => {
    const apiData = {
      ended: false,
      id: 1,
      winner: null,
      grid_height: 3,
      grid_width: 4,
      connect_what: 2,
      draw: false,
      current_player: "one",
      moves: [],
    };

    const transformedData = transformGameData(apiData);
    expect(transformedData).toEqual({
      ended: false,
      id: 1,
      winner: null,
      gridHeight: 3,
      gridWidth: 4,
      draw: false,
      connectWhat: 2,
      currentPlayer: "yellow",
      moves: [],
    });
  });

  it("transforms game data for winning game state", () => {
    const apiData = {
      ended: true,
      id: 1,
      winner: "one",
      grid_height: 10,
      grid_width: 11,
      connect_what: 6,
      draw: false,
      current_player: "two",
      moves: [
        {
          id: 1,
          x_coordinate: 0,
          y_coordinate: 0,
          player: "one",
        },
        {
          id: 2,
          x_coordinate: 0,
          y_coordinate: 1,
          player: "two",
        },
        {
          id: 3,
          x_coordinate: 0,
          y_coordinate: 2,
          player: "one",
        },
        {
          id: 4,
          x_coordinate: 0,
          y_coordinate: 3,
          player: "two",
        },
      ],
    };

    const transformedData = transformGameData(apiData);
    expect(transformedData).toEqual({
      ended: true,
      id: 1,
      winner: "yellow",
      gridHeight: 10,
      gridWidth: 11,
      draw: false,
      connectWhat: 6,
      currentPlayer: "red",
      moves: [
        {
          id: 1,
          xCoordinate: 0,
          yCoordinate: 0,
          player: "yellow",
        },
        {
          id: 2,
          xCoordinate: 0,
          yCoordinate: 1,
          player: "red",
        },
        {
          id: 3,
          xCoordinate: 0,
          yCoordinate: 2,
          player: "yellow",
        },
        {
          id: 4,
          xCoordinate: 0,
          yCoordinate: 3,
          player: "red",
        },
      ],
    });
  });
});
