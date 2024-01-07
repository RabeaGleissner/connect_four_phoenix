import React from "react";

const Coin = ({ colour }: { colour?: string }) => {
  const backgroundColour = colour ? `bg-${colour}-500` : "bg-white";
  return (
    <div className={`block w-16 h-16 ${backgroundColour} rounded-full ml-2`}>
      &nbsp;
    </div>
  );
};

export default Coin;
