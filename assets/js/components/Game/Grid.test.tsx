import React from "react";
import { render, screen, within } from "@testing-library/react";
import Grid from "./Grid";

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
});
