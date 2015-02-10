MojioClient = @MojioClient

config = {
    application: 'Your-Application-Key-Here', # Fill in your application key here
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    redirect_uri: 'Your-Logout-redirect_url-Here', # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize.html')
	live: false # Set to true if using the live environment 
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')

$( () ->
    if (config.application == 'Your-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application key in authorize_complete.js.  <br>'
        return
	if (config.redirect == 'Your-Logout-redirect_url-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set the logout redirect url in authorize_complete.js and register it in your application at the developer center.  <br>'
        return

    mojio_client.token((error, result) ->
        if (error)
            alert("Authorize Redirect, token could not be retrieved:"+error)
        else
            alert("Authorization Successful.")

            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += JSON.stringify(result)
            mojio_client.query(App, {}, (error, result) ->
                if (error)
                    div = document.getElementById('result2')
                    div.innerHTML += 'Get Apps Error'+error+'<br>'
                else
                    apps = mojio_client.getResults(App, result)

                    app = apps[0]
                    div = document.getElementById('result2')
                    div.innerHTML += 'Query /App<br>'
                    div.innerHTML += JSON.stringify(result)
                    alert("Hit Ok to log out and return to the authorization page.")
                    mojio_client.unauthorize(config.redirect_uri)
            )
    )
)

