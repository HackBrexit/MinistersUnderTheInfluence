import React from "react";
import Radium from "radium";


class Logo extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <h1 style={[
        styles.base,
      ]}>
        Ministers Under The Influence
      </h1>
    )
  }
}

var styles = {
  base: {
    float:'left',
    display: 'inline',
    lineHeight:"15vh",
  }
};

export default Radium(Logo);
