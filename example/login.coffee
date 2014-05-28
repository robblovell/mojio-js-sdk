MojioClient = @MojioClient
App = @App

config = {
    application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
    secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
    hostname: 'sandbox.api.moj.io',
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
        mojio_client.apps((error, result) ->
            if (error)
                div = document.getElementById('result2')
                div.innerHTML += 'Get Apps Error'+error+'<br>'
            else
                if (result.Data instanceof Array)
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
