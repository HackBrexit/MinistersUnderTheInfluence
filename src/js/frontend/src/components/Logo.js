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
    fontWeight:'normal',
    float:'left',
    marginLeft:'20px',
    display: 'inline',
    lineHeight:"12vh",
  }
};

export default Radium(Logo);
