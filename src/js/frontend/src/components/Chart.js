import React from "react"
import ReactDOM from "react-dom"
import Radium from "radium"

var d3Chart = require('./d3Chart');

var Chart = React.createClass({
  d3Chart: d3Chart,

  propTypes: {
    data: React.PropTypes.array
  },

  componentDidMount: function() {
    var el = ReactDOM.findDOMNode(this);
    d3Chart.create(
      el,
      {
        width: '100%',
        height: '100%'
      },
      this.getChartState()
    );
  },

  componentDidUpdate: function() {
    var el = ReactDOM.findDOMNode(this);
    d3Chart.update(el, this.getChartState());
  },

  getChartState: function() {
    return {
      data: this.props.data
    };
  },

  componentWillUnmount: function() {
    var el = ReactDOM.findDOMNode(this);
    d3Chart.destroy(el);
  },

  render: function() {
    return (
      <div
        style={[
          styles.base,
        ]}
        className="chart">
      </div>
    )
  }
});

var styles = {
  base: {
    height: "88vh",
    backgroundColor: '#2C4258',
    boxShadow: 'inset #001330 0 0px 300px -50px',
  }
}

module.exports = Radium(Chart);
