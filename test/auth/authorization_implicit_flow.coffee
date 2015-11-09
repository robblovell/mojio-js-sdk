
#MojioSDK = require '../../dist/sdk/MojioSDK'
#MojioAuthSDK = require '../../src/nodejs/sdk/MojioAuthSDK'

client_id = '41a04077-0157-49fb-a35c-6e2824f3b348'
client_secret = 'd80357f8-cbc9-4022-b340-6e99a72e7e0b'

redirect_uri = 'http://localhost:63342/mojio-js-sdk/test/auth/authorize.html'

# Authorization uri definition

sdk = new MojioSDK({
    client_id: client_id,
    client_secret: client_secret
    site: 'https://accounts.moj.io',
    tokenPath: '/oauth2/token',
    authorizationPath: '/oauth2/authorize'
    test: true,
}
)
sdk
.token(redirect_uri)
.parse(document).callback((error, result) ->
    if (error)
        console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
    else
        if !result?  or result == ""
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
