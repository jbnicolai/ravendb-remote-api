var ConsoleApp, Q, RavendbConstant, RavendbService, exports, once, ravendbUrlApi;

ConsoleApp = require('console-app');

Q = require('q');

once = require('once');

ravendbUrlApi = require('./ravendbUrlApi');

RavendbConstant = {
  databasePath: '/db/'
};

RavendbService = function() {
  this.baseDir = '';
  this.ravendbPath = "" + this.baseDir + "/RavendbConstant.databasePath";
  this.apiUrl = ravendbUrlApi;
  return this;
};

Object.defineProperty(RavendbService.prototype, 'help', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    return ConsoleApp.cmd({
      cmd: "./db/Server/Raven.Server.exe",
      args: ['-help']
    });
  }
});

Object.defineProperty(RavendbService.prototype, 'start', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    var deferred;
    deferred = Q.defer();
    this.terminate().then(function() {
      var resolve, tmp;
      resolve = once(deferred.resolve);
      tmp = ConsoleApp.run({
        cmd: "./db/Server/Raven.Server.exe",
        stdio: 'fd4Pipe',
        detached: true,
        args: []
      });
      return tmp.instance.stdout.on('data', function(data) {
        console.log(data.toString());
        return resolve(data);
      });
    })["catch"](function() {
      return console.log('error while starting ravendb');
    });
    return deferred.promise;
  }
});

Object.defineProperty(RavendbService.prototype, 'stop', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    return this.terminate();
  }
});

Object.defineProperty(RavendbService.prototype, 'terminate', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    var deferred, results, tmp;
    deferred = Q.defer();
    results = [];
    tmp = ConsoleApp.run({
      cmd: "Taskkill",
      stdio: 'fd4Pipe',
      detached: true,
      args: ['/IM', 'Raven.Server.exe', '/F']
    });
    tmp.instance.stdout.on('data', function(data) {
      console.log(data.toString());
      return results.push(data.toString());
    });
    tmp.instance.stdout.on('close', function(data) {
      return deferred.resolve(results.join(' '));
    });
    return deferred.promise;
  }
});

Object.defineProperty(RavendbService.prototype, 'backup', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: function() {
    return ConsoleApp.cmd({
      cmd: "./db/Server/Raven.Server.exe",
      args: ['-src', '[backup location]', '-dest', '[restore location]', '-restore']
    });
  }
});

Object.defineProperty(RavendbService.prototype, 'service', {
  enumerable: false,
  configurable: false,
  writable: false,
  value: {
    restart: function() {
      return ConsoleApp.cmd({
        cmd: "./db/Server/Raven.Server.exe",
        args: ['--restart']
      });
    }
  }
});

exports = module.exports = new RavendbService();
