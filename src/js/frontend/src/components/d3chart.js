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

d3Chart.translate = (x,y) => {
  return "translate(" + x + "," + y + ")";
}

d3Chart.update = function(el, state) {
    var g = d3.select(el).select('.d3-points');

    // var xScale = d3.scaleLinear()
    //     .domain([])
    //     .range();

    var bubbles = g.selectAll('g.bubble')
                      .data(state.data)
                      .enter()
                        .append("g")
                        .attr("class", "bubble")
                        .attr("transform", function(d,i) {return d3Chart.translate(i * 250, 200)});

    bubbles.append("circle")
            .attr("r", function(d) {return d.meetingCount * 10;});

    bubbles.append("text")
            .text(function(d) {return d.category;});
};

module.exports = d3Chart;
