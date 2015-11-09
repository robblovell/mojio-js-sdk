
# Test with an off the shelf authorization package.
express = require('express')
app = express()
client_id = '41a04077-0157-49fb-a35c-6e2824f3b348'
client_secret = 'd80357f8-cbc9-4022-b340-6e99a72e7e0b'
oauth2 = require('simple-oauth2')({
    clientID: client_id,
    clientSecret: client_secret,
    site: 'https://accounts.moj.io',
    tokenPath: '/oauth2/token',
    authorizationPath: '/oauth2/authorize'
})

redirect_uri = 'http://localhost:3000/callback'
# Authorization uri definition
authorization_uri = oauth2.authCode.authorizeURL({
    client_id: client_id,
    redirect_uri: redirect_uri #:3000/callback',
    scope: ['full']
#    state: '3(#0/!~'
})

# Initial page redirecting to Github
app.get('/auth', (req, res) ->
    res.redirect(authorization_uri)
)
app.get('/unauth', (req, res) ->
    console.log("res:"+res)
)

# Callback service parsing the authorization token and asking for the access token
app.get('/callback', (req, res) ->
    saveToken = (error, result) ->
        if (error)
            console.log('Access Token Error', error.message)
            res.send('Error: error.message')
        else if result?
            token = oauth2.accessToken.create(result);
            res.send('World: <br><a href="/">Unauthorize Mojio!</a><br>'+JSON.stringify(token))
        else
            res.send('Error logging in, no token returned<br><a href="/auth">Log in with Mojio: Authorization Code Flow</a><br><a href="/password">Log in with Mojio: Password Flow</a>')

        # <a href="/logout">Log out of Mojio</a><br><a href="/consent">Remove consent from Mojio</a>')

    code = req.query.code
    console.log('/callback')
    oauth2.authCode.getToken({
        code: code,
        redirect_uri: redirect_uri
    }, saveToken)

)
app.get('/password', (req, res) ->
    # Save the access token
    saveToken = (error, result) ->
        if (error)
            console.log('Access Token Error', error.message)
            res.send('Error: error.message')
        else if result?
            token = oauth2.accessToken.create(result);
            res.send('World: <br><a href="/">Unauthorize Mojio!</a><br>'+JSON.stringify(token))
        else
            res.send('Error logging in, no token returned<br><a href="/auth">Log in with Mojio: Authorization Code Flow</a><br><a href="/password">Log in with Mojio: Password Flow</a>')

    oauth2.password.getToken({
        username: 'testing@moj.io',
        password: 'Test123!'
    }, saveToken)
)

app.get('/', (req, res) ->
    res.send('Hello<br><a href="/auth">Log in with Mojio: Authorization Code Flow</a><br><a href="/password">Log in with Mojio: Password Flow</a>')
)

app.listen(3000)

console.log('Express server started on port 3000!')