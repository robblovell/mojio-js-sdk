MojioClient = @MojioClient

config = {
    application: '71dfc7e2-b1e1-4d32-9d35-abc86404de25',
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize_complete.html'
}

mojio_client = new MojioClient(config)

$( () ->

    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in login.js.  <br>'
        return

    mojio_client.authorize(config.redirect_uri)
)
