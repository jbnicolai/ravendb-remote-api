var exports, ravendbUrlApi, timestamp;

timestamp = function() {
  return (new Date).getTime();
};

ravendbUrlApi = {
  ensureStartup: function() {
    return "http://localhost:8080/silverlight/ensureStartup?noCache=-" + (timestamp());
  },
  databases: function() {
    return "http://localhost:8080/databases?pageSize=1024";
  },
  documents: function() {
    return "http://localhost:8080/docs?pageSize=0&noCache=" + (timestamp());
  },
  version: function() {
    return "http://localhost:8080/build/version?noCache=" + (timestamp());
  },
  status: function() {
    return "http://localhost:8080/stats?noCache=-" + (timestamp());
  },
  plugins: function() {
    return "http://localhost:8080/plugins/status?noCache=" + (timestamp());
  }
};

exports = module.exports = ravendbUrlApi;
