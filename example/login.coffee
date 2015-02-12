MojioClient = @MojioClient

config =     {
    application: 'bcafb90b-95b5-406f-8d2a-ad2cb7401df6',
    secret: '1e877bcf-3274-4ce9-8a16-7880dff3b3a3',
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    schema:'https',
    login: 'anonymous@moj.io',
    password: 'Password007'
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')

$( () ->

    appChangedCallback = (entity) ->
        div = document.getElementById('result6')
        div.innerHTML += 'Observed /App <br>'
        div.innerHTML += JSON.stringify(entity)

    if (config.application == 'Your-Sandbox-Application-Key-Here')
        div = document.getElementById('result')
        div.innerHTML += 'Mojio Error:: Set your application and secret keys in login.js.  <br>'
        return

    if (config.login == 'Your-Username')
        div = document.getElementById('result2')
        div.innerHTML += 'Mojio Error:: Set a username and password in login.js.  <br>'
        return

    mojio_client.login(config.login, config.password, (error, result) ->
        if (error)
            alert("Login Error:"+error)
        else
            extractToken = (hash) ->
                match = hash.match(/access_token=([0-9a-f-]{36})/)
                return !!match && match[1]
            token = extractToken(document.location.hash)
            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += '<br>Token: '+token+'<br>'
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
            )
            app = new App().mock()

            mojio_client.post(app, (error, result) ->
                if (error?)
                    div = document.getElementById('result3')
                    div.innerHTML += 'Post /App Error<br>'
                    div.innerHTML += "Error:"+error+" Posting a new app:"+app.stringify()
                else
                    div = document.getElementById('result4')
                    div.innerHTML += 'Post /App<br>'
                    div.innerHTML += JSON.stringify(result)
                    app = new App(result)
                    console.log("Starting observing!")

                    mojio_client.observe(app, null,
                        appChangedCallback
                        ,
                        (error, result) ->
                            app.Description = "Changed"
                            mojio_client.put(app, (error, result) ->
                                div = document.getElementById('result5')
                                div.innerHTML += 'Put /App changed app<br>'
                                div.innerHTML += JSON.stringify(result)
                            )
                    )
            )
            setTimeout(() ->
                app.Description = "Changed 3"
                mojio_client.put(app, (error, result) ->
                    div = document.getElementById('result7')
                    div.innerHTML += 'Put /App changed app again<br>'
                    div.innerHTML += JSON.stringify(result)
                )
                console.log("done.")
                div = document.getElementById('result8')
                div.innerHTML += 'DONE.<br>'
            ,
            5000)
    )
)