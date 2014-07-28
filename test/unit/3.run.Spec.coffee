ravendb = require '../../src/main'
fs = require('fs')

describe 'ravendb api >>', ->
  @timeout(50000)
  agent = superagent.agent()

  #==============================================================================
  # call methods
  #==============================================================================
  before (done) ->
    ravendb.cli.start().then ->
      done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should ensure startup of ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.ensureStartup())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.body.ok).to.equal true
        done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should databases ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.databases())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.status).to.equal 200
        done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should documents ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.documents())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.status).to.equal 200
        done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should version ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.version())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.status).to.equal 200
        done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should status of ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.status())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.status).to.equal 200
        done()

  #==============================================================================
  # startup database
  #==============================================================================
  it "should plugins ravendb", (done) ->
    agent
      .get(ravendb.cli.apiUrl.plugins())
      .set('Accept', 'application/json')
      .end (err, res) ->
        expect(res.status).to.equal 200
        done()

  #==============================================================================
  # stop database
  #==============================================================================
  after (done) ->
    ravendb.cli.stop().then ->
      done()
