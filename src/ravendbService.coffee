ConsoleApp = require('console-app')
Q = require('q')
once = require('once')
ravendbUrlApi = require './ravendbUrlApi'

RavendbConstant =
  databasePath: '/db/'

RavendbService = ->
  @baseDir = ''
  @ravendbPath = "#{@baseDir}/RavendbConstant.databasePath"
  @apiUrl = ravendbUrlApi
  return this

Object.defineProperty RavendbService.prototype, 'help',
  enumerable: false
  configurable: false
  writable: false
  value: ->
    ConsoleApp.cmd
      cmd: "./db/Server/Raven.Server.exe"
      args: [
        '-help'
      ]

Object.defineProperty RavendbService.prototype, 'start',
  enumerable: false
  configurable: false
  writable: false
  value: ->
    deferred = Q.defer()
    @terminate()
    .then ->
      resolve = once(deferred.resolve)
      tmp = ConsoleApp.run
        cmd: "./db/Server/Raven.Server.exe"
        stdio: 'fd4Pipe'
        detached: true
        args: []

      tmp.instance.stdout.on 'data', (data) ->
        console.log data.toString()
        resolve(data)

    .catch ->
      console.log 'error while starting ravendb'

    deferred.promise

Object.defineProperty RavendbService.prototype, 'stop',
  enumerable: false
  configurable: false
  writable: false
  value: -> @terminate()

Object.defineProperty RavendbService.prototype, 'terminate',
  enumerable: false
  configurable: false
  writable: false
  value: ->
    deferred = Q.defer()
    results = []
    tmp = ConsoleApp.run
      cmd: "Taskkill"
      stdio: 'fd4Pipe'
      detached: true
      args: ['/IM' ,'Raven.Server.exe', '/F']

    tmp.instance.stdout.on 'data', (data) ->
      console.log data.toString()
      results.push data.toString()

    tmp.instance.stdout.on 'close', (data) ->
      deferred.resolve results.join ' '

    deferred.promise

Object.defineProperty RavendbService.prototype, 'backup',
  enumerable: false
  configurable: false
  writable: false
  value: ->
    ConsoleApp.cmd
      cmd: "./db/Server/Raven.Server.exe"
      args: [
        '-src'
        '[backup location]'
        '-dest'
        '[restore location]'
        '-restore'
      ]

Object.defineProperty RavendbService.prototype, 'service',
  enumerable: false
  configurable: false
  writable: false
  value:
    restart: ->
      ConsoleApp.cmd
        cmd: "./db/Server/Raven.Server.exe"
        args: [
          '--restart'
        ]

exports = module.exports = new RavendbService()
