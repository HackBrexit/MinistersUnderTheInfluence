var d3 = require('d3');
var d3Chart = {};

d3Chart.create = function(el, props, state) {
  var svg = d3.select(el).append('svg');
  this.svg = svg;
  svg.attr('class', 'd3')
    .attr('width', props.width)
    .attr('height', props.height);

  svg.append('g')
    .attr('class', 'd3-points');

  this.update(el, state);
};

d3Chart.translate = (x, y) => {
  return "translate(" + x + "," + y + ")";
}

d3Chart.getSvgDimensions = function() {
  this.svg_el = this.svg.node();
  this.svg_el.pixelWidth = this.svg.style("width").replace("px", "");
  this.svg_el.pixelHeight = this.svg.style("height").replace("px", "");
}

d3Chart.initBubbleCoordsRadius = function(data, svg_el) {
  for (var i = 0; i < data.length; i++) {
    data[i].radius = data[i].meetingCount * 10;
    data[i].x = Math.random() * svg_el.pixelWidth;
    data[i].y = Math.random() * svg_el.pixelHeight;
  }
}

d3Chart.positionBubble = function(d, i) {
  var svg_el = d3Chart.svg_el;
  return d3Chart.translate(d.x, d.y);
}

d3Chart.update = function(el, state) {
  d3Chart.getSvgDimensions();
  d3Chart.initBubbleCoordsRadius(state.data, this.svg_el);

  var g = d3.select(el).select('.d3-points');

  // var xScale = d3.scaleLinear()
  //   .domain([])
  //   .range();

  var bubbles = g.selectAll('g.bubble')
      .data(state.data)
    .enter().append("g")
      .attr("class", "bubble")
      .attr("transform", d3Chart.positionBubble);

  bubbles.append("circle")
    .attr("r", function(d) {return d.meetingCount * 10;});

  bubbles.append("text")
    .text(function(d) {return d.category;});
};

module.exports = d3Chart;
