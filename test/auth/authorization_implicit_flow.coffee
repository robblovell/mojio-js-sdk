
#MojioSDK = require '../../dist/sdk/MojioSDK'
#MojioAuthSDK = require '../../src/nodejs/sdk/MojioAuthSDK'

client_id = '5f81657f-47f6-4d86-8213-5c01c1f3a243'
client_secret = 'fcca6c06-3d30-488e-947b-a6291e39ff3c'

redirect_uri = 'http://localhost:63342/mojio-js-sdk/test/auth/authorize.html'

# Authorization uri definition

sdk = new MojioSDK({
    client_id: client_id,
    client_secret: client_secret
    site: 'https://staging-accounts.moj.io',
    tokenPath: '/oauth2/token',
    authorizationPath: '/oauth2/authorize'
    test: true,
}
)
saveToken =

sdk.token().parse(document, redirect_uri).callback((error, result) ->
    if (error)
        console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
    else
        if result == "" or !result?
            if confirm("Authorize Redirect, token could not be retrieved, you are logged out. Try again?")
                # implicit workflow.
                sdk
                .authorize(redirect_uri)
                .scope(['full'])
                .redirect( { redirect: (url) -> window.location = url } )
        else
            # recover the token
            token = result
            console.log("Token:"+JSON.stringify(token))
            alert("Authorization Successful.")

            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += JSON.stringify(result)
            div.innerHTML += "<br>Authorization Successful.<br>"
            if confirm('You are logged in, logout and try again?')
                sdk.unauthorize(redirect_uri)
                .login()
                .consent()
                .redirect( { redirect: (url) -> window.location = url } )
)
