MojioClient = @MojioClient

#config =     {
#    application: 'f201b929-d28c-415d-9b71-8112532301cb'
#    secret: '2ef80a7a-780d-41c1-8a02-13a286f11a23'
#    hostname: '216.19.183.15'
#    version: 'v1'
#    port:'2006'
#    scheme:'http'
#    login: 'anonymous@moj.io'
#    password: 'Password007'
#    redirect_uri: 'http://localhost:63344/mojio-js/example/login.html'
#}


config = {
    application: 'f201b929-d28c-415d-9b71-8112532301cb',
    secret: '2ef80a7a-780d-41c1-8a02-13a286f11a23',
    hostname: 'staging.api.moj.io',
    version: 'v1',
    port:'443',
    scheme: 'https',
    login: 'anonymous@moj.io',
    password: 'Password007',
    redirect_uri: 'http://localhost:63344/mojio-js/example/authorize_complete.html'
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')

$( () ->
    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in login.js.  <br>'
        return

    if (config.login == 'Your-Username')
        div = document.getElementById('result2')
        div.innerHTML += 'Mojio Error:: Set a username and password in login.js.  <br>'
        return

    mojio_client.token((error, result) ->
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
                    mojio_client.unauthorize((error, result) ->
                        if (error)
                            div = document.getElementById('result3')
                            div.innerHTML += 'Logout Error'+error+'<br>'
                        else
                            div.innerHTML += '<br>Logout Success: '+result+'<br>'
                    )
            )
    )
)

