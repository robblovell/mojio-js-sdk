MojioClient = @MojioClient

config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize_complete.html'
}

mojio_client = new MojioClient(config)

$( () ->

    if (config.application == 'Your-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application key in login.js.  <br>'
        return
    if (config.application == 'Your-Login-redirect_url-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set the login redirect url in authorize.js and register it in your application at the developer center.  <br>'
        return

    mojio_client.authorize(config.redirect_uri)
)
