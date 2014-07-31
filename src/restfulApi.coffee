express = require("express")
express = require("express")
app = express()

require('expressjs-route-mapper').use(app)

exports = module.exports = (ravendb) ->

  app.routeMapper
    base: '/!/api',
    routes:
      '/service':
        '/start': 'get': (req, res) ->
          ravendb.service.start().then (data) ->
            res.send data.toString()

        '/stop': 'get': (req, res) ->
          ravendb.service.stop().then (data) ->
            res.send data.toString()

      '/database':
        '/start': 'get': (req, res) ->
          ravendb.cli.start().then (data) ->
            res.send data.toString()

        '/stop': 'get': (req, res) ->
          ravendb.cli.stop().then (data) ->
            res.send data.toString()

        '/restart': 'get': (req, res) ->
          ravendb.cli.start().then (data) ->
            res.send data.toString()

        '/reset': 'get': (req, res) ->
          res.send 'reset'

        '/plugin': 'get': (req, res) ->
          res.send 'plugin'

        '/status': 'get': (req, res) ->
          res.send 'status'

        '/listing': 'get': (req, res) ->
          res.send 'listing'

        '/documents': 'get': (req, res) ->
          res.send 'documents'

  app.listen(3000)
