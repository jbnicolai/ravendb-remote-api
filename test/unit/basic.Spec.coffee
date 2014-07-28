ravendb = require '../../src/main'
fs = require('fs')

describe 'basic setup >>', ->
  @timeout(50000)
  #==============================================================================
  # basic test
  #==============================================================================
  it "download Ravendb release", (done) ->
    ravendb.download.release(2908)
      .then ->
        file = fs.existsSync('./RavenDB-Build.zip')
        expect(file).to.equal true
        done()
      .catch ->
        throw new Error 'error while downloading file'
