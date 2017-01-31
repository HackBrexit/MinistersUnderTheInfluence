let d3 = require('d3');
let api = require('./api');

let meetingData = {
  sampleData: {
    "meetingCounts" : [
      {targetId: 0, meetingCount: 10},
      {targetId: 1, meetingCount: 20},
      {targetId: 2, meetingCount: 14},
      {targetId: 3, meetingCount: 1},
      {targetId: 4, meetingCount: 8},
      {targetId: 5, meetingCount: 5}
    ],
    "targets" : {
      0: {name: "Health"},
      1: {name: "Finance"},
      2: {name: "Arms"},
      3: {name: "IT"},
      4: {name: "Charitable Sector"},
      5: {name: "Media"}
    }
  },

  fetch: function(sourceType, sourceId, targetType, onSuccess) {
    let url = this.apiURL(sourceType, sourceId, targetType);
    console.debug("Fetching from " + url);
    d3.request(url)
      .mimeType("application/json")
      .header("Accept", "application/vnd.api+json")
      .response(function(xhr) { return JSON.parse(xhr.responseText); })
      .get(this.dataLoadedHandler(onSuccess, url,
                                  sourceType, sourceId, targetType));
  },

  apiURL: function(sourceType, sourceId, targetType) {
    return api.URL(sourceType + "/" + sourceId + "/meetings" +
                   "?include=" + targetType);
  },

  dataLoadedHandler: function(onSuccess, url, sourceType, sourceId, targetType) {
    let self = this;

    return function(error, json) {
      if (error) {
        // FIXME: make this more elegant
        let msg = "Error fetching data from " + url + ": " + error;
        alert(msg);
        console.error(msg);
        return;
      }

      if (json.data.length === 0) {
        let msg = "Didn't find any meetings for " + sourceType +
            " with id " + sourceId;
        alert(msg);
        console.warn(msg + " via " + url);
        return;
      }

      let meetingCounts = self.countMeetingsByTarget(json, targetType);

      if (json.included) {
        let targets = self.meetingTargets(json.included);
        self.lookupTargetNames(meetingCounts, targets);
      }

      onSuccess(meetingCounts);
    };
  },

  lookupTargetNames: function(meetingCounts, targets) {
    for (let i = 0; i < meetingCounts.length; i++) {
      let meetingCount = meetingCounts[i];
      let target = targets[meetingCount.targetId];
      meetingCount.targetName = target.name;
    }
  },

  // Return an array of objects, each containing the name of the
  // target and the number of meetings with that target.
  //
  // For example if meetingTargetType is "government-people" then each
  // object will represent a person in government, and a count of the
  // number of meetings which targeted that person.
  countMeetingsByTarget: function(json, meetingTargetType) {
    let data = json.data;

    let counts = {};
    for (let i = 0; i < data.length; i++) {
      let meeting = data[i];
      let rels = meeting.relationships;
      let targets = rels[meetingTargetType].data;
      // For some reason, the same target can appear multiple times in
      // the relationship data for a given meeting, so we have to
      // de-duplicate here.
      let targetCounts = {};
      for (let j = 0; j < targets.length; j++) {
        let target = targets[j];
        targetCounts[target.id] = (targetCounts[target.id] || 0) + 1;
      }
      for (let targetId in targetCounts) {
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
    let targets = {};
    for (let i = 0; i < included.length; i++) {
      let targetData = included[i];
      let targetId = targetData.id;
      let targetName = targetData.attributes.name;
      targets[targetId] = {name: targetName};
    }
    return targets;
  },
}

meetingData.lookupTargetNames(
  meetingData.sampleData.meetingCounts,
  meetingData.sampleData.targets,
);

module.exports = meetingData;
