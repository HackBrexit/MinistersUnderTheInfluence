import React from "react"

var Chart = require('./Chart');

export default class ChartContainer extends React.Component{

  constructor(props) {
    super(props);
    this.state = {
      data: [
          {entity: "Lobbyists-are-us", meetingCount: 10},
          {entity: "Defenders of freendome", meetingCount: 2}
      ]
    }
  }

  render () {
    return
    <div>
      <Chart data={this.state.data} />
    </div>
  }
}
