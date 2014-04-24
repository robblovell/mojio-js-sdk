Mojio = @Mojio

config = {
    application: 'e626b252-5e1f-48c6-a56c-54832e655c46',
    secret: '295869cf-c4ae-439b-ba9e-a0fd1423ac0a',
    hostname: 'sandbox.api.moj.io',
    version: 'v1',
    port: '80'
}

mojio = new Mojio(config);

#TODO:: make anonymous user.
mojio.login('anonymous@moj.io', 'Password007', (error, result) ->
    if (error)
        alert("error:"+error)
    else
        div = document.getElementById('result')
        div.innerHTML += 'POST /login<br>'
        div.innerHTML += JSON.stringify(result)
)
