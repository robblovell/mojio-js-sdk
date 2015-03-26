MojioClient = @MojioClient

###

    Below, fill in your application specific details to make this code work

config =
    application: 'Your-Application-Key-Here' # Fill in your application key here
    redirect_uri: 'Your-Logout-redirect_url-Here' # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize_complete.html')
    live: false # Set to true if using the live environment

###
config =
    application: 'Your-Application-Key-Here',
    hostname: 'api.moj.io'
    version: 'v1'
    port: '443'
    scheme: 'https'
    redirect_uri: 'Your-Loggout/Login-redirect_url-Here'
#    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize_complete.html'
    live: false

mojio_client = new MojioClient(config)

(() ->

    if (config.application == 'Your-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application key in authorize.coffee or .js.  <br>'
        return
    if (config.application == 'Your-Login-redirect_url-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set the login redirect url in authorize.coffee or .js and register it in your application at the developer center.  <br>'
        return
    mojio_client.token((error, result) ->
        if (error)
            alert("Logging you in by redirecting to the Mojio oAuth2 server.")
            mojio_client.authorize(config.redirect_uri)
        else
            if confirm('You are already authorized, logout and try again?')
                mojio_client.unauthorize(config.redirect_uri)
            else
                alert("You are logged in.")
    )
)()