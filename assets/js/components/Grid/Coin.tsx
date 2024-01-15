import React from "react";

const Coin = ({ colour, small }: { colour?: string; small?: boolean }) => {
  const backgroundColour = colour ? `bg-${colour}-500` : "bg-white";
  const size = small ? "w-6 h-6" : "w-16 h-16";
  return (
    <div className={`block ${size} ${backgroundColour} rounded-full ml-2`}>
      &nbsp;
    </div>
  );
};

export default Coin;
