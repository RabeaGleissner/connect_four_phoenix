import React from "react";

const Slot = ({ children }: { children: React.ReactNode }) => {
  return (
    <li className="block bg-blue-900 border-solid border-1 border-blue-900 w-20 h-20">
      {children}
    </li>
  );
};

export default Slot;
