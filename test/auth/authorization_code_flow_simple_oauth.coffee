express = require('express')
app = express()
client_id = '5f81657f-47f6-4d86-8213-5c01c1f3a243'
client_secret = 'fcca6c06-3d30-488e-947b-a6291e39ff3c'
oauth2 = require('simple-oauth2')({
    clientID: client_id,
    clientSecret: client_secret,
    site: 'https://staging-accounts.moj.io',
    tokenPath: '/oauth2/token',
    authorizationPath: '/oauth2/authorize'
})

# Authorization uri definition
authorization_uri = oauth2.authCode.authorizeURL({
    redirect_uri: 'http://localhost:3000/callback' #:3000/callback',
    scope: 'full'
#    state: '3(#0/!~'
})

# Initial page redirecting to Github
app.get('/auth', (req, res) ->
    res.redirect(authorization_uri)
)

# Callback service parsing the authorization token and asking for the access token
app.get('/callback', (req, res) ->
    code = req.query.code
    console.log('/callback')
    saveToken = (error, result) ->
        if (error)
            console.log('Access Token Error', error.message)
        token = oauth2.accessToken.create(result)
        console.log("Token:"+JSON.stringify(token))

    oauth2.authCode.getToken({
        client_id: client_id,
        client_secret: client_secret,
        code: code,
        redirect_uri: 'http://localhost:3000/callback'
    }, saveToken
    )

)

app.get('/', (req, res) ->
    res.send('Hello<br><a href="/auth">Log in with Mojio</a>')
)

app.listen(3000)

console.log('Express server started on port 3000')