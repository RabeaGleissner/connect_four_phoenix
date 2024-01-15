import React from "react";

interface CoinDropButtonProps {
  handleCoinDrop: () => void;
  isDisabled: boolean;
  loading: boolean;
}

const CoinDropButton = ({
  handleCoinDrop,
  isDisabled,
  loading,
}: CoinDropButtonProps) => {
  return (
    <button
      aria-label="Drop coin in column"
      onClick={handleCoinDrop}
      className={`cursor-pointer w-20 h-10 bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-2 border border-gray-400 rounded shadow ${
        (isDisabled || loading) && "cursor-not-allowed"
      }`}
      disabled={isDisabled}
    >
      <p className="text-xl">
        {isDisabled && <span>🚫</span>}
        {!isDisabled && <span>👇</span>}
      </p>
    </button>
  );
};

export default CoinDropButton;
