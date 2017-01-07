import React from "react";
import Radium from "radium";
import ChartContainer from "./ChartContainer";
import Header from "../components/Header";
import About from "../components/About"

class PageLayout extends React.Component {
  constructor(props) {
    super(props);
  }

  render () {
    return (
      <div
      style={[
        styles.base,
      ]}
      className="app-container">
        <Header />
        <About />
        <ChartContainer/>
      </div>
    )
  }
}

var styles = {
  base: {
    height:"100vh",
    overflow: 'hidden',
  }
}

export default Radium(PageLayout)
