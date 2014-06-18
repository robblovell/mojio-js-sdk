MojioClient = @MojioClient
App = @App

config = {
    application: '9ea750d2-7085-4125-bcd8-5e6d05d1d695',
    secret: 'e464f45a-e877-4655-b119-f7c58c10549f',
    hostname: 'develop.api.moj.io',
    version: 'v1',
    port: '80'
}

mojio_client = new MojioClient(config);

#TODO:: make anonymous user.
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
                div.innerHTML += 'Get /App<br>'
                div.innerHTML += JSON.stringify(result)
        )
)
