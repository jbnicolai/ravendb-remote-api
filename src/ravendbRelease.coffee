Download = require('download')
Q = require('q')
request = require("request")
progress = require("request-progress")
through = require("through")
chalk = require('chalk')
gutil = require('gulp-util')
fs  = require("fs")
unzip = require('unzip')

stream = through (file, enc, cb) ->
  @push(file)
  cb()

exports = module.exports = RavendbRelease = (releaseNum) ->
  deferred = Q.defer()
  RavendbRelease.download(releaseNum)
  .then ->
    deferred.resolve()
  .catch ->
    deferred.reject new Error arguments

  deferred.promise

RavendbRelease.baseUrl = (releaseNum) ->
  "http://hibernatingrhinos.com/downloads/RavenDB/#{releaseNum}"

RavendbRelease.download = (releaseNum) ->
  deferred = Q.defer()
  saveFilePath = './RavenDB-Build.zip'
  download = (url) ->
    downloadHandler = (err, res, body) ->
      fs.writeFile saveFilePath, new Buffer(body), (err) ->
        process.stdout.write " " + chalk.green("Done\n")
        stream.emit "end"
        stream.end()

    firstLog = true
    if typeof url is "object"
      fileName = url.file
      url = url.url
    else
      fileName = url.split("/").pop()
    progress(request(
      url: url
      encoding: null
    , downloadHandler),
      throttle: 1000
      delay: 1000
    ).on("progress", (state) ->
      process.stdout.write " " + state.percent + "% >>"
    ).on "data", ->
      if firstLog
        process.stdout.write "[" + chalk.green("Ravendb") + "]" + " Downloading " + chalk.cyan(url) + "..."
        firstLog = false

  download RavendbRelease.baseUrl releaseNum

  stream.on 'error', ->
    deferred.reject new Error arguments

  stream.on 'close', ->
    fs.createReadStream(saveFilePath)
      .pipe(unzip.Extract
        path: './db/'
      ).on 'close', ->
        deferred.resolve()

  deferred.promise



mkdir = (path) ->
  deferred = Q.defer()
  fs.mkdir path, (error) ->
    if not e or (e and e.code is 'EEXIST')
      deferred.resolve()
    else
      deferred.reject error
  deferred.promise
