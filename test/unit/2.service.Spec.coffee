ravendb = require '../../src/main'
fs = require('fs')

describe 'ravendb >>', ->
  @timeout(50000)

  #==============================================================================
  # call methods
  #==============================================================================
  it "return help method", (done) ->
    ravendb.cli.help()
    .then (data) ->
      expect(data).to.contain '--help'
      done()
    .catch done

  #==============================================================================
  # start database
  #==============================================================================
  it "should start ravendb", (done) ->
    ravendb.cli.start().then ->
      done()

  #==============================================================================
  # stop database
  #==============================================================================
  it "should stop ravendb", (done) ->
    ravendb.cli.stop().then ->
      done()
