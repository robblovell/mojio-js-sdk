# mojio-js

Mojio javascript REST client.  Mojio provides a standard REST platform for writing connected car applications.

This repository contains a node js client and a browser js client.

The client is built in coffeescript and compiled to js for use in the browser and node-js environments.  Built code
is in the /dist directory.

The browser client needs jquery to work properly.  See the example directory for usage in
example/login.html.

## Test:
```
npm install
bower install
mocha
```

## Build
All javascript client code is in the 'dist' directory.

Code must be compiled from coffeescript to javascript first.  Browser based code must be "browserified" to work in a
browser. A webstorm project is setup to compile the coffeescript code, call browserify and to copy all built code
to the dist directory.

If you need to manually recompile the code, the steps are:

For nodejs code
```
coffee --map --output src/nodejs --compile src/nodejs/Mojio.coffee
cp src/nodejs/*.js dist/nodejs/
```

For browser code
```
cd src/browser
coffee --map --compile Mojio.coffee
coffee --map --compile HttpBrowser.coffee
browserify -r ./HttpBrowser.js --standalone HttpBrowser > ../../dist/browser/HttpBrowser.js
browserify -r ./Mojio.js --standalone Mojio > ../../dist/browser/Mojio.js
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
<script src="./dist/browser/HttpBrowser.js"></script>
<script src="./dist/browser/Mojio.js"></script>
<script src="./login.js"></script>
</body>

Mojio = @Mojio
```
login.coffee (compiles to login.js included in the html above)
```
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
       <script src="./dist/browser/HttpBrowser.js"></script>
       <script src="./dist/browser/Mojio.js"></script>
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
               hostname: 'staging.api.moj.io',
               version: 'v1',
               port:'80'
             }
    Mojio = require '../dist/nodejs/Mojio.js'
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
    hostname: 'staging.api.moj.io',
    version: 'v1',
    port: '80'
  };

  Mojio = require('../dist/nodejs/Mojio.js');

  mojio = new Mojio(config);

  mojio.login('YOUR USERNAME', 'YOUR PASSWORD', function(error, result) {
    if (error) {
      return console.log("error: " + error);
    } else {
      return console.log("success:" + result);
    }
  });
```

## Todo:

Make browser code compile from nodejs client.
Need models
POST, PUT, DELETE for resources.
Hyperlinks for resources
