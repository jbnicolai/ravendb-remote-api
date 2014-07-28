
timestamp = ->
  (new Date).getTime()

ravendbUrlApi =
  ensureStartup: ->
    "http://localhost:8080/silverlight/ensureStartup?noCache=-#{timestamp()}"

  databases: ->
    "http://localhost:8080/databases?pageSize=1024"

  documents: ->
    "http://localhost:8080/docs?pageSize=0&noCache=#{timestamp()}"

  version: ->
    "http://localhost:8080/build/version?noCache=#{timestamp()}"

  status: ->
    "http://localhost:8080/stats?noCache=-#{timestamp()}"

  plugins: ->
    "http://localhost:8080/plugins/status?noCache=#{timestamp()}"

exports = module.exports = ravendbUrlApi
