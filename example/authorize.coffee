MojioClient = @MojioClient

#config = {
#    application: 'f201b929-d28c-415d-9b71-8112532301cb',
#    secret: '2ef80a7a-780d-41c1-8a02-13a286f11a23',
#    hostname: '216.19.183.15',
#    version: 'v1',
#    port:'2006',
#    scheme: 'http',
#    login: 'anonymous@moj.io',
#    password: 'Password007',
#    redirect_uri: 'http://localhost:63344/mojio-js/example/authorize_complete.html'
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

    mojio_client.authorize(config.login, config.password, 'full', config.redirect_uri, (error, result) ->
        if (error)
            alert("Authorize Error:"+error)
        else
            alert("Authorization Started:")
    )
)
