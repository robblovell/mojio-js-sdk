MojioClient = @MojioClient

config =     {
    application: 'bcafb90b-95b5-406f-8d2a-ad2cb7401df6',
    secret: '1e877bcf-3274-4ce9-8a16-7880dff3b3a3',
    hostname: 'api.moj.io',
    version: 'v1',
    port:'443',
    login: 'anonymous@moj.io',
    password: 'Password007',
    scheme: 'https'
}

mojio_client = new MojioClient(config)
App = mojio_client.model('App')
Vehicle = mojio_client.model('Vehicle')
Mojio = mojio_client.model('Mojio')
Event = mojio_client.model('Event')

$( () ->

    eventChangedCallback = (entity) ->
        div = document.getElementById('result7')
        div.innerHTML += 'Observed /Event <br>'
        div.innerHTML += JSON.stringify(entity)
        console.log("Observed Event! "+entity)

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
            mojio_client.query(Vehicle, {}, (error, result) ->
                if (error)
                    div = document.getElementById('result2')
                    div.innerHTML += 'Get Vehicle Error'+error+'<br>'
                else
                    vehicles = mojio_client.getResults(Vehicle, result)

                    vehicle = vehicles[0]
                    div = document.getElementById('result2')
                    div.innerHTML += 'Query /Vehicle<br>'
                    div.innerHTML += JSON.stringify(result)

                    console.log("Observing vehicle's events")

                    mojio_client.observe(vehicle, "TripStatus",
                        eventChangedCallback
                    ,
                    (error, result) ->
                        if (error)
                            console.log("error:"+error)
                        else
                            console.log("Observing of vehicle's events started!")
                    )
            )
    )
)
