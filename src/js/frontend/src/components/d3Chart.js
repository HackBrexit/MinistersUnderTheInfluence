// Obtain a list of meetings attended by a given individual or a given
// organisation / department, and then visualise who they met with as
// bubbles, where the size of the bubble is how often they met with
// them.

// FIXME: make this constant configurable
let RADIUS_SCALE = 25;

let d3 = require('d3');
let meetingData = require('./meetingData');

let d3Chart = {
  initChart: function(topdiv, svg, meetingCounts) {
    d3Chart.getSvgDimensions(svg);
    d3Chart.initBubbleCoordsRadius(svg, meetingCounts);

    d3Chart.force = d3Chart.initForceSimulation(svg, meetingCounts);

    d3Chart.update(topdiv, svg, meetingCounts);
  },

  getSvgDimensions: function(svg) {
    let sel = d3.select(svg);
    svg.pixelWidth = sel.style("width").replace("px", "");
    svg.pixelHeight = sel.style("height").replace("px", "");
    svg.centreX = svg.pixelWidth / 2;
    svg.centreY = svg.pixelHeight / 2;
  },

  initBubbleCoordsRadius: function(svg, data) {
    for (let i = 0; i < data.length; i++) {
      data[i].radius = Math.sqrt(data[i].meetingCount) * RADIUS_SCALE;
      data[i].x = Math.random() * svg.pixelWidth;
      data[i].y = Math.random() * svg.pixelHeight;
    }
  },

  translate: function(x, y) {
    return "translate(" + x + "," + y + ")";
  },

  positionBubble: function(d, i) {
    return d3Chart.translate(d.x, d.y);
  },

  bubbleRadius: function(d, i) {
    return d.radius + 2;
  },

  initForceSimulation: function(svg, meetingCounts) {
    return d3.forceSimulation(meetingCounts)
      //.force("charge", d3.forceManyBody().strength(-1000))
      .force("centerX", d3.forceX(svg.centreX))
      .force("centerY", d3.forceY(svg.centreY))
      .force("collide", d3.forceCollide()
                          .radius(d3Chart.bubbleRadius)
                          .iterations(3))
      .force("center", d3.forceCenter(svg.centreX, svg.centreY))
      .on("tick", this.tickHandler);
  },

  tickHandler: function() {
    d3Chart.updateBubblePositions();
  },

  updateBubblePositions: function() {
      this.bubbles.attr("transform", this.positionBubble);
  },

  update: function(topdiv, svg, data) {
    let g = d3.select(svg).select('.d3-points');

    let tooltip = d3.select(topdiv).append("div")
                .attr("class", "tooltip")
                .style("opacity", 0);

    this.bubbles = g.selectAll('g.bubble')
        .data(data)
      .enter().append("g")
        .attr("class", "bubble")
        .on("mouseover", function(d) {
           tooltip.transition()
             .duration(200)
             .style("opacity", 1);
           tooltip.html("<strong>" + d.targetName + "</strong>"+ "<br /> " + "Meetings: " + d.meetingCount)
             .style("left", (d3.event.pageX) + "px")
             .style("top", (d3.event.pageY) + "px");
           })
        .on("mousemove", function() {
          tooltip.style("left", (d3.event.pageX ) + "px")
            .style("top", (d3.event.pageY) + "px");
        })
        .on("mouseout", function(d) {
           tooltip.transition()
             .duration(200)
             .style("opacity", 0);
           });

    this.updateBubblePositions();

    this.bubbles.append("circle")
      .attr("r", function(d) {return d.radius;});

    this.bubbles.append("text")
      .text(function(d) {return d.targetName;})
      .style("font-size", this.bubbleTextFontSize)
      .style("font-weight", "bold")
  },

  bubbleTextFontSize: function(d) {
    return Math.min(
      2 * d.radius,
      (2 * d.radius - 8) / this.getComputedTextLength() * 15
    ) + "px";
  },

  destroy: function() {
  },
};

module.exports = d3Chart;
