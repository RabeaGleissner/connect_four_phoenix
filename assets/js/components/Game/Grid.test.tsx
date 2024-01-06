import React from "react";
import { render, screen } from "@testing-library/react";
import Grid from "./Grid";

describe(Grid, () => {
  it("renders without errors", () => {
    render(<Grid />);
    const text = screen.getByText(/the grid/i);
  });
});
