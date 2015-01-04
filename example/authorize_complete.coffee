MojioClient = @MojioClient

#config = {
#    application: 'f201b929-d28c-415d-9b71-8112532301cb',
#    hostname: 'api.moj.io',
#    version: 'v1',
#    port:'443',
#    scheme: 'https',
#    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize.html'
#}

config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    secret: 'f0927a0a-386b-4148-be8d-5ffd7468ea6b',
    hostname: '10.211.55.3',
    version: 'v1',
    port:'2006',
    scheme: 'http',
    redirect_uri: 'http://localhost:63342/mojio-js/example/authorize_finish.html'
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')

$( () ->
    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in authorize.js.  <br>'
        return
    code = mojio_client.access_code()

    mojio_client.request_token(code, (error, result) ->
        if (error)
            alert("Authorize Redirect, token could not be retreived:"+error)
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
                    #alert("Hit Ok to log out and return to the authorization page.")
                    #mojio_client.unauthorize(config.redirect_uri)
            )
    )
)

