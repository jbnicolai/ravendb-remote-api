ravendb = require '../../src/main'
fs = require('fs')

describe.skip 'basic setup >>', ->
  @timeout(50000)
  #==============================================================================
  # basic test
  #==============================================================================
  it "download Ravendb release", (done) ->
    ravendb.download.release(2908)
      .then ->
        file = fs.existsSync('./db/RavenDB-Build.zip')
        expect(file).to.equal true
        done()
      .catch ->
        throw new Error 'error while downloading file'
