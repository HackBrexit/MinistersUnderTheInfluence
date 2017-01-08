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
        Ministers Under <small>the</small> <span style={styles.highlightWord}>Influence</span>
      </h1>
    )
  }
}

var styles = {
  base: {
    fontWeight: 'normal',
    float: 'left',
    marginLeft: '20px',
    display: 'inline',
    lineHeight: "12vh",
    color: '#119DA4',
    margin: '0 0 0 20px',
  },

  highlightWord: {
    color: '#e65c5a',
    fontWeight: 'bold',

  },
  span: {
    fontWeight:'bold',
  }
};

export default Radium(Logo);
