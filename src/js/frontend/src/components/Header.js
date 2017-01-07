import React from "react";
import Radium from "radium";
import Logo from "./Logo";
import Navigation from "./Navigation";

class Header extends React.Component {
  constructor(props) {
    super(props)
  }

  render() {
    return (
      <header
      style={[
        styles.base,
      ]}>
        <Logo />
        <Navigation />
      </header>
    )
  }
}

var styles = {
  base: {
    // backgroundColor: '#F5F5ED',
    height: "15vh",
  }
};

export default Radium(Header);
