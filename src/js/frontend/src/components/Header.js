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
    height: "15vh",
    lineHeight:"15vh",
    color: "#733a70",
    textAlign: "center",
    backgroundRepeat: "no-repeat",
    backgroundSize: "15vh 15vh",
    backgroundPosition :"10%",
    borderBottom: "1px solid #733a70"
  }
};

export default Radium(Header);
