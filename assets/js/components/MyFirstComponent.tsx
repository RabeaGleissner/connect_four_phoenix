import React from "react";

interface MyFirstComponentProps {
  name: string;
}

const MyFirstComponent = ({ name }: MyFirstComponentProps) => {
  return (
    <>
      <p>Hello {name}</p>
      <div>React component with TS</div>
    </>
  );
};

export default MyFirstComponent;
