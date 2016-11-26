import React from "react"
import Radium from "radium"
import ChartContainer from "./ChartContainer"
import HeaderContainer from "./HeaderContainer"

export default class PageLayout extends React.Component{

  constructor(props) {
    super(props);
  }

  render () {
    return (
      <div className="app-container">
        <HeaderContainer/>
        <ChartContainer/>
      </div>
    )
  }
}
