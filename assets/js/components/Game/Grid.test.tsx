import React from "react";
import "@testing-library/jest-dom";
import { render, screen, within } from "@testing-library/react";
import Grid from "./Grid";
import { Move } from "../../types/Move";

describe(Grid, () => {
  it("renders empty grid when there are no moves", () => {
    const gridWidth = 3;
    const gridHeight = 4;
    render(<Grid moves={[]} width={gridWidth} height={gridHeight} />);

    const columns = screen.getAllByRole("list");
    expect(columns).toHaveLength(gridWidth);

    const firstColumnRows = within(columns[0]).getAllByRole("listitem");
    expect(firstColumnRows).toHaveLength(gridHeight);
  });

  it("renders grid with moves in the first column", () => {
    const gridWidth = 2;
    const gridHeight = 5;
    const moves: Move[] = [
      { id: 1, xCoordinate: 0, yCoordinate: 0, player: "one" },
      { id: 2, xCoordinate: 0, yCoordinate: 1, player: "two" },
      { id: 3, xCoordinate: 0, yCoordinate: 2, player: "one" },
    ];
    render(<Grid moves={moves} width={gridWidth} height={gridHeight} />);

    const columns = screen.getAllByRole("list");
    expect(columns).toHaveLength(gridWidth);

    const firstColumnSlots = within(columns[0]).getAllByRole("listitem");
    expect(firstColumnSlots).toHaveLength(gridHeight);
    expect(firstColumnSlots[0].firstChild).toHaveClass("bg-white");
    expect(firstColumnSlots[1].firstChild).toHaveClass("bg-white");
    expect(firstColumnSlots[2].firstChild).toHaveClass("bg-yellow-500");
    expect(firstColumnSlots[3].firstChild).toHaveClass("bg-red-500");
    expect(firstColumnSlots[4].firstChild).toHaveClass("bg-yellow-500");
  });
});
