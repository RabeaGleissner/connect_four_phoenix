import React from "react";
import { Move } from "../../../types/Move";
import Slot from "./Slot";
import Coin from "./Coin";

const Column = ({
  slots,
  index,
  columnMoves,
}: {
  slots: number[];
  index: number;
  columnMoves: Move[];
}) => {
  return (
    <ul>
      {slots.map((slot) => (
        <Slot data-x-coord={slot} data-y-coord={index} key={`${slot}${index}`}>
          <Coin colour={columnMoves[slot] && columnMoves[slot].player} />
        </Slot>
      ))}
    </ul>
  );
};

export default Column;
