import React from "react";
import "@testing-library/jest-dom";
import { render, screen } from "@testing-library/react";
import GameState from "./GameState";

describe("GameState", () => {
  it("shows winner when game is won", () => {
    render(<GameState winner="red" draw={false} />);

    expect(
      screen.getByText(/Game over! Player \"red\" wins./)
    ).toBeInTheDocument();
    expect(screen.queryByText(/It's a draw./)).not.toBeInTheDocument();
  });

  it("shows draw when there is a draw", () => {
    render(<GameState draw={true} winner={null} />);

    expect(screen.getByText(/Game over! It's a draw./)).toBeInTheDocument();
    expect(screen.queryByText(/Player/)).not.toBeInTheDocument();
  });

  it("shows which player goes next", () => {
    render(<GameState winner={null} draw={false} currentPlayer={"red"} />);

    expect(screen.getByText(/Next player: red/)).toBeInTheDocument();
  });

  it("does not show next player indicator when game is draw", () => {
    render(<GameState winner={null} draw={true} currentPlayer={"red"} />);

    expect(screen.queryByText(/Next player: red/)).not.toBeInTheDocument();
  });

  it("does not show next player indicator when game has winner", () => {
    render(<GameState winner="yellow" draw={false} currentPlayer={"red"} />);

    expect(screen.queryByText(/Next player: red/)).not.toBeInTheDocument();
  });
});
