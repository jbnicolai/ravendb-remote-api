var app, exports, express;

express = require("express");

express = require("express");

app = express();

require('expressjs-route-mapper').use(app);

exports = module.exports = function(ravendb) {
  app.routeMapper({
    base: '/!/api',
    routes: {
      '/service': {
        '/start': {
          'get': function(req, res) {
            return ravendb.service.start().then(function(data) {
              return res.send(data.toString());
            });
          }
        },
        '/stop': {
          'get': function(req, res) {
            return ravendb.service.stop().then(function(data) {
              return res.send(data.toString());
            });
          }
        }
      },
      '/database': {
        '/start': {
          'get': function(req, res) {
            return ravendb.cli.start().then(function(data) {
              return res.send(data.toString());
            });
          }
        },
        '/stop': {
          'get': function(req, res) {
            return ravendb.cli.stop().then(function(data) {
              return res.send(data.toString());
            });
          }
        },
        '/restart': {
          'get': function(req, res) {
            return ravendb.cli.start().then(function(data) {
              return res.send(data.toString());
            });
          }
        },
        '/reset': {
          'get': function(req, res) {
            return res.send('reset');
          }
        },
        '/plugin': {
          'get': function(req, res) {
            return res.send('plugin');
          }
        },
        '/status': {
          'get': function(req, res) {
            return res.send('status');
          }
        },
        '/listing': {
          'get': function(req, res) {
            return res.send('listing');
          }
        },
        '/documents': {
          'get': function(req, res) {
            return res.send('documents');
          }
        }
      }
    }
  });
  return app.listen(3000);
};
