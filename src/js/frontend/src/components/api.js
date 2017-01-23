var api = {
  // FIXME: make this configurable
  host: "localhost",
  port: 3000,
  protocol: "http",
  apiPathPrefix: "/api/v1/",

  URL: function (path) {
    return this.protocol + "://" + this.host + ":" + this.port +
      this.apiPathPrefix + path;
  }
}

module.exports = api;
