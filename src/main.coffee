RavendbRelease = require './ravendbRelease'

exports = module.exports = ->

module.exports.download = {}

Object.defineProperty module.exports, 'download',
  enumerable: false
  configurable: false
  writable: false
  value:
    release: (releaseNumber) ->
      return throw new Error 'missing release number' unless releaseNumber
      RavendbRelease releaseNumber

