let d3 = require('d3');
let api = require('./api');

let entityData = {
  fetch: function(entityType, entityId, onSuccess) {
    let url = this.apiURL(entityType, entityId);
    console.debug("Fetching from " + url);
    d3.request(url)
      .mimeType("application/json")
      .header("Accept", "application/vnd.api+json")
      .response(function(xhr) { return JSON.parse(xhr.responseText); })
      .get(this.dataLoadedHandler(onSuccess, url, entityType, entityId));
  },

  apiURL: function(entityType, entityId) {
    return api.URL(entityType + "/" + entityId);
  },

  dataLoadedHandler: function(onSuccess, url, entityType, entityId) {
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
        let msg = "Didn't find any meetings for " + entityType +
            " with id " + entityId;
        alert(msg);
        console.warn(msg + " via " + url);
        return;
      }

      onSuccess(json);
    };
  },
}

module.exports = entityData;
