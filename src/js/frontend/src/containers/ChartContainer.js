import React from "react"
import Radium from "radium"

var Chart = require('../components/Chart');

class ChartContainer extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: [
        {category: "Health", meetingCount: 10},
        {category: "Finance", meetingCount: 20},
        {category: "Arms", meetingCount: 14},
        {category: "IT", meetingCount: 1},
        {category: "Charitable Sector", meetingCount: 8},
        {category: "Media", meetingCount: 5}
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
