import React from "react"
import Radium from "radium"
import ChartContainer from "./ChartContainer"
import Header from "../components/Header"

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
        <ChartContainer/>
      </div>
    )
  }
}

var styles = {
  base: {
    height:"100vh",
    overflow:"hidden"
  }
}

export default Radium(PageLayout)
