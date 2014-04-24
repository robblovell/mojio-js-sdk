Mojio = @Mojio

config = {
    #application: 'e626b252-5e1f-48c6-a56c-54832e655c46',
    #secret: '295869cf-c4ae-439b-ba9e-a0fd1423ac0a',

    application: '0c7dccc6-810a-489a-9675-30a112d03cb8',
    secret: 'dd52b356-a41c-4a7f-b268-07b7b742c05a',
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
