MojioClient = @MojioClient
App = @App

config =     {
    application: '9ea750d2-7085-4125-bcd8-5e6d05d1d695',
    secret: 'e464f45a-e877-4655-b119-f7c58c10549f',
    hostname: '192.168.0.105',
    version: 'v1',
    port:'2006'
}

mojio_client = new MojioClient(config);
$( () ->
    appChangedCallback = (entity) ->
        div = document.getElementById('result6')
        div.innerHTML += 'Observed /App <br>'
        div.innerHTML += JSON.stringify(entity)

    mojio_client.login('anonymous@moj.io', 'Password007', (error, result) ->
        if (error)
            alert("Login Error:"+error)
        else
            div = document.getElementById('result')
            div.innerHTML += 'POST /login<br>'
            div.innerHTML += JSON.stringify(result)
            mojio_client.query(App, {}, (error, result) ->
                if (error)
                    div = document.getElementById('result2')
                    div.innerHTML += 'Get Apps Error'+error+'<br>'
                else
                    if (result instanceof Array)
                        app = new App(result[0])
                    else if (result.Data instanceof Array)
                        app = new App(result.Data[0])
                    else if (result.Data?)
                        app = new App(result.Data)
                    else
                        app = new App(result)

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
