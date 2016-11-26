import React from "react"
import Radium from "radium"
import ChartContainer from "./ChartContainer"

export default class PageLayout extends React.Component{

  constructor(props) {
    super(props);
  }

  render () {
    return <ChartContainer/>
  }
}
