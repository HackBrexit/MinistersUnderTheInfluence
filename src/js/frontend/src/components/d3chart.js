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

    // var xScale = d3.scaleLinear()
    //     .domain([])
    //     .range();


    g.selectAll("circle")
        .data(state.data)
        .enter()
        .append("circle")
        .attr("cx", function(d, i) {return i * 250;})
        .attr("cy", function(d, i) {return 200;})
        .attr("r", function(d) {return d.meetingCount * 10;});

    g.selectAll("text")
        .data(state.data)
        .enter()
        .append("text")
        .attr("x", function(d, i) {return i * 250;})
        .attr("y", function(d, i) {return 200;})
        .attr("fill", "red")
        .text(function(d) {return d.entity;});
};

module.exports = d3Chart;