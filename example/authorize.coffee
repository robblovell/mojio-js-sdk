MojioClient = @MojioClient

config = {
    application: 'Your-Application-Key-Here', # Fill in your application key here
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'Your-Login-redirect_url-Here', # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize_complete.html')
	live: false # Set to true if using the live environment 
}

mojio_client = new MojioClient(config)

$( () ->

    if (config.application == 'Your-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application key in authorize.js.  <br>'
        return
    if (config.application == 'Your-Login-redirect_url-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set the login redirect url in authorize.js and register it in your application at the developer center.  <br>'
        return

    mojio_client.authorize(config.redirect_uri)
)
