import React from "react";
import { createRoot } from "react-dom/client";

import Game from "./components/Game/Game";

export default function renderGame(container: ReactDOM.Container) {
  const root = createRoot(container as Element);
  root.render(<Game />);
}
