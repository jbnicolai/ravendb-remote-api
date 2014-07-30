var RavendbRelease, exports, ravendbService, restfulApi;

RavendbRelease = require('./ravendbRelease');

ravendbService = require('./ravendbService');

restfulApi = require('./restfulApi');

exports = module.exports = function() {};

module.exports.download = {};

Object.defineProperty(module.exports, 'download', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: {
    release: function(releaseNumber) {
      if (!releaseNumber) {
        throw new Error('missing release number');
      }
      return RavendbRelease(releaseNumber);
    }
  }
});

Object.defineProperty(module.exports, 'cli', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: ravendbService
});

Object.defineProperty(module.exports, 'server', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    return restfulApi(module.exports);
  }
});
