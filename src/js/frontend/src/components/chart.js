import React from "react"
import ReactDOM from "react-dom"
import Radium from "radium"
var d3Chart = require('./d3Chart');

var Chart = React.createClass({
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
            this.getChartState());
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
            className="Chart">
            </div>
        )
    }
});

var styles = {
  base: {
    height: "85vh"
  }
}

module.exports = Radium(Chart);
