import React from "react"
import Radium from "radium"

var Chart = require('../components/Chart');

class ChartContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: [
        {name: "Health", meetingCount: 10},
        {name: "Finance", meetingCount: 20},
        {name: "Arms", meetingCount: 14},
        {name: "IT", meetingCount: 1},
        {name: "Charitable Sector", meetingCount: 8},
        {name: "Media", meetingCount: 5}
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
