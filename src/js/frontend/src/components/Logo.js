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
        <span style={[styles.span]}>Ministers Under </span> the <span style={[styles.span]}>Influence</span>
      </h1>
    )
  }
}

var styles = {
  base: {
    fontWeight:'100',
    float:'left',
    marginLeft:'20px',
    display: 'inline',
    lineHeight:"12vh",
  },
  span: {
    fontWeight:'bold',
  }
};

export default Radium(Logo);
