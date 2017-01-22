import React from "react"
import ReactDOM from "react-dom"
import Radium from "radium"

var d3Chart = require('./d3Chart');
var meetingData = require('./meetingData');

var Chart = React.createClass({
  d3Chart: d3Chart,

  propTypes: {
    data: React.PropTypes.object,
    sourceType: React.PropTypes.string.isRequired,
    sourceId: React.PropTypes.string,
    targetType: React.PropTypes.string,
  },

  render: function() {
    return (
      <div
        style={[
          styles.base,
        ]}
        className="chart" ref="topdiv">
        <svg className="d3" ref="svg"
             width={this.props.width}
             height={this.props.height}>
          <g className="d3-points" />
        </svg>
      </div>
    )
  },

  componentDidMount: function() {
    this.getData();
  },

  getData: function() {
    if (this.props.sourceType === "demo") {
      this.componentGotData(meetingData.sampleData["meetingCounts"]);
    }
    else {
      var self = this;
      meetingData.fetch(
        this.props.sourceType,
        this.props.sourceId,
        this.props.targetType,
        function (meetingCounts) {
          self.componentGotData(meetingCounts);
        }
      );
    }
  },

  componentGotData: function(meetingCounts) {
    d3Chart.initChart(this.refs.topdiv, this.refs.svg, meetingCounts);
  },

  componentDidUpdate: function() {
    this.getData();
  },

  componentWillUnmount: function() {
    var el = ReactDOM.findDOMNode(this);
    d3Chart.destroy(el);
  },
});

var styles = {
  base: {
    height: "88vh",
    backgroundColor: '#2C4258',
    boxShadow: 'inset #001330 0 0px 300px -50px',
  }
}

module.exports = Radium(Chart);
