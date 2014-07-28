require('coffee-script/register')
require('coffee-errors')

chai = require('chai')
should = require('should')
assert = require("assert")
superagent = require('superagent')
supertest = require('supertest')

# chai plugins
chai.use(require 'chai-as-promised')
chai.use(require('chai-fs'))

# publish globals that all specs can use
global.expect = chai.expect
global.should = chai.should()
global.supertest = supertest
global.assert = assert
global.superagent = superagent
global.should = should
global.port = process.env.PORT
