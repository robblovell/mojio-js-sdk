# mojio-js

Mojio javascript REST client.  Mojio provides a standard REST platform for writing connected car applications.

This repository contains a Node-js client and a Browser based js client.

For browser based HTML applications you get this client via Bower:

```
bower install mojio-js
```

Or via the Mojio CDN at https://djaqzxyxnyyiy.cloudfront.net

```
<script src="https://djaqzxyxnyyiy.cloudfront.net/mojio-js.js"></script>
```

If you are in a node envirionment, use npm:

```
npm install mojio-js
```

You can always checkout this repo and use the code directly.
All distributions for the browser are in the "dist" directory.
All distributions for Node-js are in the "lib" directory.

The client is built from mustache files using combyne.
The builder generates coffeescript files which are then compiled to js for use in the browser
in the /dist directory and for use in node-js environments in the /lib directory.

The browser client needs jquery to work properly.  See the example and test directories for how to use this client.

Look here in the repository:
```
example/login.html
test/login_test.coffee
```
[![build status](https://travis-ci.org/mojio/mojio-js.svg?branch=master)](https://travis-ci.org/mojio/mojio-js)
## Install and Test:
```
npm install
bower install
mocha
```
You may need to install coffeescript, bower, browserify, and mocha:
```
npm install -g coffee
npm install -g bower
npm install -g browserify
npm install -g mocha
```
## HTML Example

### CoffeeScript:
```
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>title</title>
</head>
<body>
<div id="result"></div>
<script src="./bower_components/jquery/dist/jquery.js"></script>
<script src="./dist/browser/HttpBrowserWrapper.js"></script>
<script src="./dist/browser/MojioClient.js"></script>
<script src="./login.js"></script>
</body>
```
login.coffee (compiles to login.js included in the html above)
```
Mojio = @Mojio

config = {
    application: 'YOUR APPLICATION KEY',
    secret: 'YOUR SECRET KEY',
    hostname: 'sandbox.api.moj.io',
    version: 'v1',
    port: '80'
}

mojio = new Mojio(config);

mojio.login('YOUR USERNAME', 'YOUR PASSWORD', (error, result) ->
    if (error)
        alert("error:"+error)
    else
        div = document.getElementById('result')
        div.innerHTML += 'POST /login<br>'
        div.innerHTML += JSON.stringify(result)
)
```
### JavaScript:
```
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>title</title>
</head>
<body>
<div id="result"></div>
<script src="./bower_components/jquery/dist/jquery.js"></script>
<script src="./dist/browser/HttpBrowserWrapper.js"></script>
<script src="./dist/browser/MojioClient.js"></script>
<script type="text/javascript">
    (function() {
        var Mojio, config, mojio;

        Mojio = this.Mojio;

        config = {
            application: 'YOUR APPLICATION KEY',
            secret: 'YOUR SECRET KEY',
            hostname: 'sandbox.api.moj.io',
            version: 'v1',
            port: '80'
        };

        mojio = new Mojio(config);

        mojio.login('YOUR USERNAME', 'YOUR PASSWORD', function(error, result) {
            var div;
            if (error) {
                return alert("error:" + error);
            } else {
                div = document.getElementById('result');
                div.innerHTML += 'POST /login<br>';
                return div.innerHTML += JSON.stringify(result);
            }
        });

    }).call(this);
</script>

</body>
```
## Node JS Example

### CoffeeScript:
```
config = {
           application: 'YOUR APPLICATION KEY',
           secret: 'YOUR SECRET KEY',
           hostname: 'sandbox.api.moj.io',
           version: 'v1',
           port:'80'
         }
Mojio = require './lib/MojioClient.js'
mojio = new Mojio(config)

mojio.login('YOUR USERNAME', 'YOUR PASSWORD', (error, result) ->
    if error then console.log("error: "+error) else console.log("success:"+result)
)
```
### JavaScript
```
var Mojio, mojio, config;

config = {
  application: 'YOUR APPLICATION KEY',
  secret: 'YOUR SECRET KEY',
  hostname: 'sandbox.api.moj.io',
  version: 'v1',
  port: '80'
};

Mojio = require('./lib/MojioClient.js');

mojio = new Mojio(config);

mojio.login('YOUR USERNAME', 'YOUR PASSWORD', function(error, result) {
  if (error) {
    return console.log("error: " + error);
  } else {
    return console.log("success:" + result);
  }
});
```

## Build
All javascript client code is in the 'dist' directory.

Code is generate first by running the generator in /src/generate.coffee. The generator makes a request to the schema
REST endpoint and retrieves all the schemas for objects stored in the database and creates model files, calls to
the REST endpoints in the client, and tests for those calls.

```
cd src
coffee generate.coffee
```

This creates:
```
browser/MojioClient.coffee
nodejs/MojioClient.coffee
models/Address.coffee
models/App.coffee
models/Location.coffee
models/Mojio.coffee
models/Trip.coffee
models/User.coffee
models/Vehicle.coffee
../test/App_test.coffee
../Mojio_test.coffee
../Trip_test.coffee
../User_test.coffee
../Vehicle_test.coffee
```

These files are not created by the generator:
```
browser/HttpBrowserWrapper.coffee
nodejs/HttpBrowserWrapper.coffee
models/MojioModel.coffee
models/schema.coffee
../test/crud_test.cofffee
../test/events_test.cofffee
../test/login_test.cofffee
../test/schema_test.cofffee
```

Once the code is generated, it must be compiled from coffeescript to javascript and copied to the dist and lib directories.
Browser based code must be "browserified" to work in a browser.

If you need to manually recompile the code, the steps are:

For nodejs code
```
coffee --map --compile src/nodejs
cp src/nodejs/*.js lib/
```
For browser code
```
coffee --map --compile src/browser
cd src/browser
browserify -r ./HttpBrowserWrapper.js --standalone HttpBrowserWrapper > ../../dist/browser/HttpBrowserWrapper.js
browserify -r ./MojioClient.js --standalone Mojio > ../../dist/browser/MojioClient.js
```

## Todo:

* Needs all the models, missing event.coffee
* POST, PUT, DELETE for resources.
* Hyperlinks for resources
* Observer and Subscription endpoints
* Fix mocha test on travis CI
