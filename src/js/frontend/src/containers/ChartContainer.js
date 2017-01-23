import React from "react"
import Radium from "radium"
import { Link } from 'react-router'

let Chart = require('../components/Chart');

class ChartContainer extends React.Component {
  render () {
    return <div className="chart-container">
      <Link to="/">Back to home</Link>
      <Chart width="100%" height="100%"
             sourceType={this.props.route.sourceType}
             sourceId={this.props.params.id}
             targetType={this.props.params.targetType} />
    </div>
  }
}

export default Radium(ChartContainer);
