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
    className="chart-container"
    style={[
      styles.base,
    ]}>
      <Chart
      data={this.state.data} />
    </div>
  }
}

var styles = {
  base: {
    height: "85vh"
  }
}

export default Radium(ChartContainer);
