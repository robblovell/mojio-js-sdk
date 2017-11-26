# Configuration
# Fill in your application specific details to make this code work
config =
    application: '0310fd43-beb0-407a-8dcd-c521e339b4f8' # Fill in your application key here
    live: true # Set 'live' to true if using the live environment, set it to false to use the simulator
    redirect_uri: 'http://localhost:63342/mojio-js/examples/browser/authorize.html' # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize.html')

app =
    application: '0310fd43-beb0-407a-8dcd-c521e339b4f8' # Fill in your application key here
    redirect_uri: 'http://localhost:63342/mojio-js/examples/browser/authorize.html' # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize.html')
    scope: 'full'

# Instantiate a mojio client object
mojio_client = new @MojioClient(config)
# Create a user model object to help with calls to the SDK.
User = mojio_client.model('User')

(() ->
    # Start out by checking to see if a token is available
    mojio_client.token((error, result) ->
        if (error)
            # If a token is not available, confirm that we are redirecting to Mojio's authorization server to login the user.
            if confirm("Authorize Redirect, You are logged out right now (a Token doesn't exist yet). Try to log in?")
                # Redirect to the authorization server. Mojio will collect the user's credentials, verify them, and redirect back to the redirect url you have specified.
                mojio_client.authorize(config.redirect_uri, "token", app.scope)
        else
            # At this point, the token is available and we are logged in. Show the token and get the current user
            alert("Authorization Successful.")
            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += JSON.stringify(result)
            # Make a call to get the current user.
            mojio_client.get(User, {}, (error, result) ->
                if (error)
                    # Show an error that the current user couldn't be retrieved.
                    div = document.getElementById('result2')
                    div.innerHTML += 'Get User Error'+error+'<br>'
                else
                    # New up a user object and show it's fields in the html.
                    users = mojio_client.getResults(User, result)

                    user = users[0]
                    div = document.getElementById('result2')
                    div.innerHTML += 'Query /User<br>'
                    div.innerHTML += JSON.stringify(user)
                    # Offer to log out the user to restart the demo cycle.
                    if confirm('You are logged in, logout and try again?')
                        mojio_client.unauthorize(config.redirect_uri)
            )
    )
)()

