import React from "react"
import Radium from "radium"

let Chart = require('../components/Chart');

class ChartContainer extends React.Component {
  render () {
    return <div className="chart-container">
      <Chart width="100%" height="100%"
             sourceType={this.props.route.sourceType}
             sourceId={this.props.params.id}
             targetType={this.props.params.targetType} />
    </div>
  }
}

export default Radium(ChartContainer);
