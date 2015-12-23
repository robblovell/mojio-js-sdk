# Using mojio's auth SDK.
express = require('express')
MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioAuthSDK = require '../../src/nodejs/sdk/MojioAuthSDK'

app = express()
client_id = '42c6dfd7-1a58-4fcf-9a94-e287d40cfec7'
client_secret = '1d7d8c3b-7fbc-48bd-b7b7-8549598bfdbb'
oauth2 = require('simple-oauth2')({
    clientID: client_id,
    clientSecret: client_secret,
    site: 'https://accounts.moj.io',
    tokenPath: '/oauth2/token',
    authorizationPath: '/oauth2/authorize'
})
redirect_uri = 'http://localhost:3000/callback'
redirect_uri2 = 'http://localhost:3000/callback'

# Authorization uri definition
authorization_uri = oauth2.authCode.authorizeURL({
    client_id: client_id,
    redirect_uri: redirect_uri #:3000/callback',
    scope: ['full']
#    state: '3(#0/!~'
})
sdk = new MojioSDK({
        sdk: MojioAuthSDK,
        client_id: client_id,
        client_secret: client_secret
        environment: "staging",
    }
)
# Initial page redirecting to Github
app.get('/authCode', (req, res) ->
    console.log("res:"+res)
    # step 1 of authorization code workflow.
    sdk
    .authorize(redirect_uri)
    .scope(['full'])
    .redirect(res)
)
app.get('/password', (req, res) ->
    console.log("res:"+res)
    sdk
    .token(redirect_uri)
    .credentials("testing@moj.io", "Test123!")
    .scope(['full'])
    .callback((error, result) ->
        if (error)
            console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
            res.send('Access Token Error: '+JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
        else
            token = result
            console.log("Token:"+JSON.stringify(token))
            res.send('World: <br><a href="/unauth">Unauthorize Mojio</a><br><a href="/logout">Log out of Mojio</a><br><a href="/consent">Remove consent from Mojio</a>')
    )
)

app.get('/logout', (req, res) ->
    console.log("res:"+res)
    loggedOut = (error, result) ->
        console.log("logged out")
    sdk
    .unauthorize("http://localhost:3000/callback")
    .login()
    .redirect(res)

#    res.redirect(redirect_url)
)
app.get('/consent', (req, res) ->
    console.log("res:"+res)
    loggedOut = (error, result) ->
        console.log("Removed Consent")
    sdk
    .unauthorize("http://localhost:3000/callback")
    .consent()
    .redirect(res)

#    res.redirect(redirect_url)
)
app.get('/unauth', (req, res) ->
    console.log("res:"+res)
    loggedOut = (error, result) ->
        console.log("logged out and removed consent")
    sdk
    .unauthorize("http://localhost:3000/callback")
    .login()
    .consent()
    .redirect(res)

#    res.redirect(redirect_url)
)

# Callback service parsing the authorization token and asking for the access token
app.get('/callback', (req, res) ->
    code = req.query.code
    console.log('/callback')
    saveToken = (error, result) ->
        if (error)
            console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
            res.send('Access Token Error: '+JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
        else
            # recover the token
            # todo:: recover token from mojio sdk.
            token = result
            console.log("Token:"+JSON.stringify(token))
            res.send('World: <br><a href="/unauth">Unauthorize Mojio</a><br><a href="/logout">Log out of Mojio</a><br><a href="/consent">Remove consent from Mojio</a>')

    sdk.token(redirect_uri).parse(req).callback(saveToken)
)

app.get('/', (req, res) ->
    res.send('Hello<br><a href="/authCode">Log in with Mojio: Authorization Code Flow</a><br><a href="/password">Log in with Mojio: Password Flow</a>')
)

app.listen(3000)

console.log('Express server started on port 3000')