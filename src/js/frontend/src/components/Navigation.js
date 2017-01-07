import React from "react";
import Radium from "radium";

class Navigation extends React.Component{

  constructor(props) {
    super(props)
  }

  render() {
    return (
      <nav style={[
        styles.base,
      ]}>
        <ul>
          <li>
            About
          </li>
          <li>
            Hack Brexit
          </li>
        </ul>
      </nav>
    )
  }
}

var styles = {
  base: {

  }
};

export default Radium(Navigation);
