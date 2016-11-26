import React from "react"
import Radium from "radium"
import ChartContainer from "./ChartContainer"
import HeaderContainer from "./HeaderContainer"

class PageLayout extends React.Component{

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
        <HeaderContainer/>
        <ChartContainer/>
      </div>
    )
  }
}

var styles = {
  base: {
    position:"absolute",
    top: "0",
    bottom: "0",
    right: "0",
    left: "0",
    overflow:"hidden"
  }
}

export default Radium(PageLayout)
