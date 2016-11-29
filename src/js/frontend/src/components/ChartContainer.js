import React from "react"
import Radium from "radium"

var Chart = require('./Chart');

class ChartContainer extends React.Component{

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
    return <div
    className="chart-container">
      <Chart
      data={this.state.data} />
    </div>
  }
}



export default Radium(ChartContainer);
