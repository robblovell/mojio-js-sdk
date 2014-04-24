Mojio = @Mojio

config = {
    application: 'cc1dd242-6b43-40bb-b07e-3333495cf384',
    secret: 'a7f7a71d-8f92-4793-a54f-e501790771b9',
    hostname: 'sandbox.api.moj.io',
    version: 'v1',
    port: '80'
}

mojio = new Mojio(config);

mojio.login('mojio', 'mojioR0cks', (error, result) ->
    if (error)
        alert("error:"+error)
    else
        div = document.getElementById('result')
        div.innerHTML += 'POST /login<br>'
        div.innerHTML += JSON.stringify(result)
)

