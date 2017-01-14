import React from "react"
import Radium from "radium"

var Chart = require('../components/Chart');

class ChartContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: {
        "meetingCounts" : [
          {targetId: 0, meetingCount: 10},
          {targetId: 1, meetingCount: 20},
          {targetId: 2, meetingCount: 14},
          {targetId: 3, meetingCount: 1},
          {targetId: 4, meetingCount: 8},
          {targetId: 5, meetingCount: 5}
        ],
        "targets" : {
          0: {name: "Health"},
          1: {name: "Finance"},
          2: {name: "Arms"},
          3: {name: "IT"},
          4: {name: "Charitable Sector"},
          5: {name: "Media"}
        }
      }
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
