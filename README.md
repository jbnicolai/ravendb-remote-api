ravendb-remote-api
======================
> A JavaScript library for accessing RavenDB API

## About

  The motivation with this module is to provide a high-level abstraction of RavenDB using express.js. It is written in JavaScript, and is 100% MIT licensed.

  * a simple, easy method for generating restful routes for a model.

## Install

```js
npm install ravendb-remote-api --save
```

Here is an example on how to use it:

## Example

### Download RavenDB Release

```js
  ravendb.download.release(2908).then(function() {
    var file;
    file = fs.existsSync('./db/RavenDB-Build.zip');
    expect(file).to.equal(true);
    return done();
  }).catch(function() {
    throw new Error('error while downloading file');
  });

```

### Start RavenDB Manually

```js
  ravendb.cli.start().then(function() {
    return done();
  });

```


### Stop all instance of RavenDB Manually

```js
  ravendb.cli.stop().then(function() {
    return done();
  });

```

### Stop all instance of RavenDB Manually

```js
  ravendb.cli.stop().then(function() {
    return done();
  });

```
## Todo
* cli api for ensure startup
* cli api for get all databases
* cli api for get all documents
* cli api for get aversion
* cli api for get status
* cli api for get installed plugins
* start windows service
* stop windows service
* run in memory
* run anonymous
* run debug mode
* install/remove analyzers
* install/remove plugin
* delete log folder
* delete database folder

## License
  [MIT](http://opensource.org/licenses/MIT) © [Carlos Marte](http://carlosmarte.me/)
