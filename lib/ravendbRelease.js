var Download, Q, RavendbRelease, chalk, clean, exports, fs, grunt, gutil, mkdirp, progress, request, rimraf, stream, through, unzip;

Download = require('download');

Q = require('q');

request = require("request");

progress = require("request-progress");

through = require("through");

chalk = require('chalk');

gutil = require('gulp-util');

fs = require("fs");

unzip = require('unzip');

grunt = require('grunt');

clean = require('gulp-clean');

rimraf = require('rimraf');

mkdirp = require('mkdirp');

stream = through(function(file, enc, cb) {
  this.push(file);
  return cb();
});

exports = module.exports = RavendbRelease = function(releaseNum) {
  var deferred;
  deferred = Q.defer();
  RavendbRelease.clean('./db').then(function() {
    process.stdout.write("[" + chalk.green("Setup") + "]" + " Deleted " + chalk.cyan("" + __dirname + "/db/") + "...");
    return RavendbRelease.download(releaseNum).then(function() {
      return deferred.resolve();
    });
  });
  return deferred.promise;
};

RavendbRelease.baseUrl = function(releaseNum) {
  return "http://hibernatingrhinos.com/downloads/RavenDB/" + releaseNum;
};

RavendbRelease.download = function(releaseNum) {
  var deferred, download, saveFilePath;
  deferred = Q.defer();
  saveFilePath = './db/RavenDB-Build.zip';
  download = function(url) {
    var downloadHandler, fileName, firstLog;
    downloadHandler = function(err, res, body) {
      return mkdirp('./db/', function(error) {
        return fs.writeFile(saveFilePath, new Buffer(body), function(err) {
          process.stdout.write(" " + chalk.green("Done\n"));
          stream.emit("end");
          return stream.end();
        });
      });
    };
    firstLog = true;
    if (typeof url === "object") {
      fileName = url.file;
      url = url.url;
    } else {
      fileName = url.split("/").pop();
    }
    return progress(request({
      url: url,
      encoding: null
    }, downloadHandler), {
      throttle: 1000,
      delay: 1000
    }).on("progress", function(state) {
      return process.stdout.write(" " + state.percent + "% >>");
    }).on("data", function() {
      if (firstLog) {
        process.stdout.write("[" + chalk.green("Ravendb") + "]" + " Downloading " + chalk.cyan(url) + "...");
        return firstLog = false;
      }
    });
  };
  download(RavendbRelease.baseUrl(releaseNum));
  stream.on('error', function() {
    return deferred.reject(new Error(arguments));
  });
  return stream.on('close', function() {
    fs.createReadStream(saveFilePath).pipe(unzip.Extract({
      path: './db/'
    })).on('close', function() {
      return deferred.resolve();
    });
    return deferred.promise;
  });
};

RavendbRelease.clean = function(path) {
  var deferred;
  deferred = Q.defer();
  rimraf(path, function() {
    return deferred.resolve();
  });
  return deferred.promise;
};

RavendbRelease.mkdir = function(path) {
  var deferred;
  deferred = Q.defer();
  fs.mkdir(path, function(error) {
    return deferred.resolve();
  });
  return deferred.promise;
};
