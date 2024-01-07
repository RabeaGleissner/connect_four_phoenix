import { transformGameData } from "./transformData";

describe("transformData", () => {
  it("transforms game data from API to game data for the UI", () => {
    const apiData = {
      ended: false,
      id: 1,
      winner: null,
      grid_height: 10,
      grid_width: 11,
      connect_what: 6,
      moves: [
        {
          id: 1,
          x_coordinate: 0,
          y_coordinate: 0,
          player: "one",
          coordinates: null,
        },
        {
          id: 2,
          x_coordinate: 0,
          y_coordinate: 1,
          player: "two",
          coordinates: null,
        },
        {
          id: 3,
          x_coordinate: 0,
          y_coordinate: 2,
          player: "one",
          coordinates: null,
        },
        {
          id: 4,
          x_coordinate: 0,
          y_coordinate: 3,
          player: "two",
          coordinates: null,
        },
      ],
    };

    const transformedData = transformGameData(apiData);
    expect(transformedData).toEqual({
      ended: false,
      id: 1,
      winner: null,
      gridHeight: 10,
      gridWidth: 11,
      connectWhat: 6,
      moves: [
        {
          id: 1,
          xCoordinate: 0,
          yCoordinate: 0,
          player: "one",
        },
        {
          id: 2,
          xCoordinate: 0,
          yCoordinate: 1,
          player: "two",
        },
        {
          id: 3,
          xCoordinate: 0,
          yCoordinate: 2,
          player: "one",
        },
        {
          id: 4,
          xCoordinate: 0,
          yCoordinate: 3,
          player: "two",
        },
      ],
    });
  });
});
