import React from "react";
import Radium from "radium";


class Logo extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <h1>
        Ministers Under The Influence
      </h1>
    )
  }
}

var styles = {
  base: {

  }
};

export default Radium(Logo);
