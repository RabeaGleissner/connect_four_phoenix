import React from "react";

interface GridProps {
  moves: string[];
  width: number;
  height: number;
}

const Grid = ({ moves, width, height }: GridProps) => {
  return (
    <div className="flex">
      {rangeUpTo(width).map((colIndex) => (
        <div key={colIndex}>
          <Column height={height} index={colIndex} />
        </div>
      ))}
    </div>
  );
};

const Column = ({ height, index }: { height: number; index: number }) => {
  return (
    <ul>
      {rangeUpTo(height).map((rowIndex) => (
        <Slot
          data-x-coord={rowIndex}
          data-y-coord={index}
          key={`${rowIndex}${index}`}
        />
      ))}
    </ul>
  );
};

const Slot = () => {
  return <li className="border-solid border-1 border-stone-50 w-10 -h-10"></li>;
};

const rangeUpTo = (n: number) => [...Array(n).keys()];

export default Grid;
