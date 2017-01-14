// FIXME: make these constants configurable

var RADIUS_SCALE = 10;

var API_URL = "http://localhost:3000/api/v1/";

// If you want to use hard-coded data, change to false
var USE_API = true;

// We obtain a list of meetings attended by a given individual or a
// given organisation / department, and then visualise who they met
// with as bubbles, where the size of the bubble is how often they met
// with them.
var MEETING_SOURCE_TYPE = "organisations"; // (Only used when USE_API is true.)

// You'll need to change this to a valid organisation id within your
// database:
var MEETING_SOURCE_ID = 194;

// This is what the bubbles represent:
var MEETING_TARGET_TYPE = "government-people";

var d3 = require('d3');
var d3Chart = {
  create: function(reactComponent, props, state) {
    var svg = d3.select(reactComponent).append('svg');
    this.reactComponent = reactComponent;
    this.svg = svg;
    svg.attr('class', 'd3')
      .attr('width', props.width)
      .attr('height', props.height);

    svg.append('g')
      .attr('class', 'd3-points');

    if (USE_API) {
      var url = API_URL + "organisations/194/meetings?include=" + MEETING_TARGET_TYPE;
      d3.request(url)
        .mimeType("application/json")
        .header("Accept", "application/vnd.api+json")
        .response(function(xhr) { return JSON.parse(xhr.responseText); })
        .get(this.dataLoaded);
    }
    else {
      this.dataLoaded(null, state.data);
    }
  },

  // Return an array of objects, each containing the name of the
  // target and the number of meetings with that target.
  //
  // For example if meetingTargetType is "government-people" then each
  // object will represent a person in government, and a count of the
  // number of meetings which targeted that person.
  countMeetingsByTarget: function(json, meetingTargetType) {
    var data = json["data"];

    var counts = {};
    for (var i = 0; i < data.length; i++) {
      var meeting = data[i];
      var rels = meeting["relationships"];
      var targets = rels[meetingTargetType]["data"];
      // For some reason, the same target can appear multiple times in
      // the relationship data for a given meeting, so we have to
      // de-duplicate here.
      var targetCounts = {};
      for (var j = 0; j < targets.length; j++) {
        var target = targets[j];
        targetCounts[target["id"]] = (targetCounts[target["id"]] || 0) + 1;
      }
      for (var targetId in targetCounts) {
        counts[targetId] = (counts[targetId] || 0) + 1;
      }
    }

    return Object.keys(counts).map(function(targetId, i) {
      return { targetId: targetId, meetingCount: counts[targetId] };
    });
  },

  // The "included" section of the JSON API's response is an array of
  // objects, each representing the target of a meeting.  Transform
  // this into an object keyed by target id, so we can efficiently map
  // target ids to names or any other attributes of the target which
  // we might want to visualise.
  meetingTargets: function(included) {
    var targets = {};
    for (var i = 0; i < included.length; i++) {
      var targetData = included[i];
      var targetId = targetData["id"];
      var targetName = targetData["attributes"]["name"];
      targets[targetId] = {name: targetName};
    }
    return targets;
  },

  dataLoaded: function(error, json) {
    if (error) {
      // FIXME: make this more elegant
      alert("Error fetching data from API: " + error);
    }

    var targets =
        USE_API ?
          d3Chart.meetingTargets(json["included"])
        : json["targets"];

    var meetingCounts =
        USE_API ?
          d3Chart.countMeetingsByTarget(json, MEETING_TARGET_TYPE)
        : json["meetingCounts"];

    d3Chart.lookupTargetNames(meetingCounts, targets);

    d3Chart.getSvgDimensions();
    d3Chart.initBubbleCoordsRadius(meetingCounts, d3Chart.svg_el);

    d3Chart.force = d3Chart.initForceSimulation(meetingCounts);

    d3Chart.update(d3Chart.reactComponent, meetingCounts);
  },

  lookupTargetNames: function(meetingCounts, targets) {
    for (var i = 0; i < meetingCounts.length; i++) {
      var meetingCount = meetingCounts[i];
      var target = targets[meetingCount["targetId"]];
      meetingCount["targetName"] = target["name"];
    }
  },

  getSvgDimensions: function() {
    this.svg_el = this.svg.node();
    this.svg_el.pixelWidth = this.svg.style("width").replace("px", "");
    this.svg_el.pixelHeight = this.svg.style("height").replace("px", "");
    this.svg_el.centreX = this.svg_el.pixelWidth / 2;
    this.svg_el.centreY = this.svg_el.pixelHeight / 2;
  },

  initBubbleCoordsRadius: function(data, svg_el) {
    for (var i = 0; i < data.length; i++) {
      data[i].radius = data[i].meetingCount * RADIUS_SCALE;
      data[i].x = Math.random() * svg_el.pixelWidth;
      data[i].y = Math.random() * svg_el.pixelHeight;
    }
  },

  translate: function(x, y) {
    return "translate(" + x + "," + y + ")";
  },

  positionBubble: function(d, i) {
    var svg_el = d3Chart.svg_el;
    return d3Chart.translate(d.x, d.y);
  },

  bubbleRadius: function(d, i) {
    return d.radius + 2;
  },

  initForceSimulation: function(data) {
    return d3.forceSimulation(data)
      //.force("charge", d3.forceManyBody().strength(-1000))
      .force("centerX", d3.forceX(d3Chart.svg_el.centreX))
      .force("centerY", d3.forceY(d3Chart.svg_el.centreY))
      .force("collide", d3.forceCollide()
                          .radius(d3Chart.bubbleRadius)
                          .iterations(3))
      .force("center", d3.forceCenter(d3Chart.svg_el.centreX,
                                      d3Chart.svg_el.centreY))
      .on("tick", this.tickHandler);
  },

  tickHandler: function() {
    d3Chart.updateBubblePositions();
  },

  updateBubblePositions: function() {
      this.bubbles.attr("transform", this.positionBubble);
  },

  update: function(reactComponent, data) {
    var g = d3.select(reactComponent).select('.d3-points');

    // var xScale = d3.scaleLinear()
    //   .domain([])
    //   .range();

    var tooltip = d3.select(".chart").append("div")
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
      .style("font-size", function(d) { return Math.min(2*d.radius, (2 * d.radius - 8) / this.getComputedTextLength() * 10) + "px"; })
  }
};

module.exports = d3Chart;
