MojioClient = @MojioClient

config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    secret: 'f0927a0a-386b-4148-be8d-5ffd7468ea6b',
    hostname: '10.211.55.3',
    version: 'v1',
    port:'2006',
    scheme: 'http',
    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize_complete.html'
}

mojio_client = new MojioClient(config)

$( () ->

    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in login.js.  <br>'
        return

    mojio_client.authenticate(config.redirect_uri)
)
