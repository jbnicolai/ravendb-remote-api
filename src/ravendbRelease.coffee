Download = require('download')
Q = require('q')
request = require("request")
progress = require("request-progress")
through = require("through")
chalk = require('chalk')
gutil = require('gulp-util')
fs  = require("fs")
unzip = require('unzip')
grunt = require('grunt')
clean = require('gulp-clean')
rimraf = require('rimraf')
mkdirp = require('mkdirp')

stream = through (file, enc, cb) ->
  @push(file)
  cb()

exports = module.exports = RavendbRelease = (releaseNum) ->
  deferred = Q.defer()
  RavendbRelease.clean('./db').then ->
    process.stdout.write "[" + chalk.green("Setup") + "]" + " Deleted " + chalk.cyan("#{__dirname}/db/") + "..."
    RavendbRelease.download(releaseNum).then ->
      deferred.resolve()
  deferred.promise

RavendbRelease.baseUrl = (releaseNum) ->
  "http://hibernatingrhinos.com/downloads/RavenDB/#{releaseNum}"

RavendbRelease.download = (releaseNum) ->
  deferred = Q.defer()
  saveFilePath = './db/RavenDB-Build.zip'
  download = (url) ->
    downloadHandler = (err, res, body) ->
      mkdirp './db/', (error) ->
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
      ).on('close', -> deferred.resolve())
    deferred.promise

RavendbRelease.clean = (path) ->
  deferred = Q.defer()
  rimraf path, ->
    deferred.resolve()
  deferred.promise

RavendbRelease.mkdir = (path) ->
  deferred = Q.defer()
  fs.mkdir path, (error) ->
    deferred.resolve()

  deferred.promise
