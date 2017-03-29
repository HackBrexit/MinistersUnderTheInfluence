let d3 = require('d3');
let api = require('./api');
import axios from "axios"

let entityData = {
  apiURL: function(entityType, entityId) {
    return api.URL(entityType + "/" + entityId);
  },

  validTypes: [
      "organisations", "people", "government-offices"
  ],

  isValidType: function(entityType) {
    return this.validTypes.indexOf(entityType) >= 0;
  },

  // FIXME: retire this in favour of fetchEntitiesRequest() below
  fetch: function(entityType, entityId, onSuccess) {
    let url = this.apiURL(entityType, entityId);
    console.debug("Fetching from " + url);
    d3.request(url)
      .mimeType("application/json")
      .header("Accept", "application/vnd.api+json")
      .response(function(xhr) { return JSON.parse(xhr.responseText); })
      .get(this.dataLoadedHandler(onSuccess, url, entityType, entityId));
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

  fetchEntitiesRequest: function (entityType) {
    return axios.get(api.fetchEntitiesURL(entityType), {
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/vnd.api+json"
      },
    });
  }
}

module.exports = entityData;
