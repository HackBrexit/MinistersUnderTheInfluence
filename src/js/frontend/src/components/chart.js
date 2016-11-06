import React from "react"
import ReactDOM from "react-dom"
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
                height: '300px'
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
            <div className="Chart"></div>
        )
    }
});

module.exports = Chart;
