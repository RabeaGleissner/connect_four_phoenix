import React from "react";
import { createRoot } from "react-dom/client";

import GameContainer from "./components/Game/GameContainer";

export default function renderGame(container: ReactDOM.Container) {
  const root = createRoot(container as Element);
  root.render(<GameContainer />);
}
