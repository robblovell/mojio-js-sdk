# Configuration
# Fill in your application specific details to make this code work
config =
    application: 'Your-Application-Key-Here' # Fill in your application key here
    hostname: 'api.moj.io'
    version: 'v1'
    port: '443'
    scheme: 'https'
    redirect_uri: 'Your-Logout-redirect_url-Here' # Fill in your redirect url here (Ex. 'http://localhost:63342/mojio-js/example/authorize.html')
    live: false # Set 'live' to true if using the live environment, set it to false to use the simulator

# Instantiate a mojio client object
mojio_client = new @MojioClient(config)
# Create a user model object to help with calls to the SDK.
User = mojio_client.model('User')

(() ->
    # This part of the example just checks to make sure you have entered your application key and secret key in the configuration
    if (config.application == 'Your-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application key in authorize_complete.js.  '
        return

    if (config.redirect_uri == 'Your-Logout-redirect_url-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set the logout redirect url in authorize_complete.js and register it in your application at the developer center.  '
        return

    # Start out by checking to see if a token is available
    mojio_client.token((error, result) ->
        if (error)
            # If a token is not available, confirm that we are redirecting to Mojio's authorization server to login the user.
            if confirm("Authorize Redirect, You are logged out right now (a Token doesn't exist yet). Try to log in?")
                # Redirect to the authorization server. Mojio will collect the user's credentials, verify them, and redirect back to the redirect url you have specified.
                mojio_client.authorize(config.redirect_uri) # after authentication, the user will be redirected back to this url.  In the example, the location is the html that includes this code.
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