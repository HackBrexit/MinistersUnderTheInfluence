var d3 = require('d3');
var d3Chart = {};

d3Chart.create = function(el, props, state) {
    var svg = d3.select(el)
        .append('svg')
        .attr('class', 'd3')
        .attr('width', props.width)
        .attr('height', props.height);

    svg.append('g')
        .attr('class', 'd3-points');

    this.update(el, state);
};

d3Chart.update = function(el, state) {
    var g = d3.select(el).select('.d3-points');

    g.selectAll("circle")
        .data(state.data)
        .enter()
        .append("circle")
        .attr("cx", function(d) {return d.cx;})
        .attr("cy", function(d) {return d.cy;})
        .attr("r", function(d) {return d.r;});
};

module.exports = d3Chart;