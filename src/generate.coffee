fs = require('fs')
Combyne = require('combyne')

fs.readFile('./models/schema.coffee', (err, data) ->
    throw err if (err)

    result = JSON.parse(data)

    fs.readFile('./models/ModelTemplate.mustache', (err, data) ->
        model_template = Combyne(data.toString())
        fs.readFile('../test/TestTemplate.mustache', (err, data) ->
            test_template = Combyne(data.toString())
            fs.readFile('../test/TestTemplate_Short.mustache', (err, data) ->
                short_test_template = Combyne(data.toString())
                models = []
                i=0
                for model, schema of result
#                    console.log("Looking at "+model)

                    continue if (model != "App" && model != "Login" && model != "Address" && model != "Location" && model != "Trip" &&
                        model != "User" && model != "Vehicle"  && model != "Event" && model != "Mojio" &&
                        model != "Subscription" && model != "Product" && model != "Observer" &&
                        model != "AccelerationObserver" && model != "AccelerometerObserver" &&
                        model != "AltitudeObserver" && model != "BatteryVoltageObserver" &&
                        model != "ConditionalObserver" && model != "DiagnosticCodeObserver" &&
                        model != "DistanceObserver" && model != "EventObserver" &&
                        model != "FuelLevelObserver" && model != "GeoFenceObserver" &&
                        model != "HeadingObserver" && model != "OdometerObserver" &&
                        model != "RPMObserver" && model != "ScriptObserver" && model != "SpeedObserver")

#                    console.log("Processing "+model)

                    view = {
                        Resource: model+"s"
                        Model: model
                        model: model.toLowerCase()
                        schema: ""
                    }
                    if model == "Login"
                        view.Resource = model

                    if (model == "Event")
                        # agregate all the Event based objects into one schema.
                        for event_model, event_schema of result
                            if (event_model.indexOf("Event") != -1)
                                for field, type of event_schema
                                    schema[field] = type

                    str = JSON.stringify(schema,null,4)
                    spl = str.split('\n')
                    for s in spl
                        view['schema'] += '            '+s+'\n'

                    output = model_template.render(view)
                    wstream = fs.createWriteStream("./models/"+model+".coffee")
                    wstream.write(output)
                    wstream.end()

                    continue if ( model == "Address" || model == "Location" || model == "Observer" ||
                        model == "AccelerationObserver" || model == "AccelerometerObserver" ||
                        model == "AltitudeObserver" || model == "BatteryVoltageObserver" ||
                        model == "ConditionalObserver" || model == "DiagnosticCodeObserver" ||
                        model == "DistanceObserver" || model == "EventObserver" ||
                        model == "FuelLevelObserver" || model == "GeoFenceObserver" ||
                        model == "HeadingObserver" || model == "OdometerObserver" ||
                        model == "RPMObserver" || model == "ScriptObserver" || model == "SpeedObserver")

                    if (model != "Vehicle" && model != "Login")
                        # these models have problems with put, post delete.
                        if (model == "Event" || model == "Subscription" || model == "Trip" || model == "User")
                            output = short_test_template.render(view)
                        else
                            output = test_template.render(view)
                        wstream = fs.createWriteStream("../test/"+model+"_test.coffee")
                        wstream.write(output)
                        wstream.end()

                    models[i++] = view

                fs.readFile('./MojioClientTemplate.mustache', (err, data) ->
                    client_template = Combyne(data.toString())
                    # node js.
                    view['models'] = models
                    view['http_require'] = "Http = require './HttpNodeWrapper'"
                    view['http_request'] = "http = new Http()"
                    view['token_requester'] = "@getTokenId()"
                    view['token_requester_implicit'] = "(() -> return null)"
                    view['signalr_default_scheme'] = 'http'
                    view['signalr_default_port'] = '80'
                    view['extra_signalr_params'] = "" # none.
                    view['signalr_require'] = "SignalR = require './SignalRNodeWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./nodejs/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()

                    # browser
                    view['http_require'] = "Http = require './HttpBrowserWrapper'"
                    view['http_request'] = "http = new Http()"
                    view['token_requester'] = "(() -> return document.location.hash.match(/access_token=([0-9a-f-]{36})/))"
                    view['token_requester_implicit'] = "(() -> return document.location.hash.match(/access_token=([0-9a-f-].+?)&/))"
                    view['extra_signalr_params'] = ", $"
                    view['signalr_default_scheme'] = 'https'
                    view['signalr_default_port'] = '443'
                    view['signalr_require'] = "SignalR = require './SignalRBrowserWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./browser/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()

                    # titanium
                    view['http_require'] = "Http = require './HttpTitaniumWrapper'"
                    view['http_request'] = "http = new Http()"
                    view['token_requester'] = "@getTokenId()"
                    view['token_requester_implicit'] = "(() -> return null)"
                    view['extra_signalr_params'] = ""
                    view['signalr_default_scheme'] = 'https'
                    view['signalr_default_port'] = '443'
                    view['signalr_require'] = "SignalR = require './SignalRTitaniumWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./titanium/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()

                    # cordova
                    view['http_require'] = "Http = require './HttpCordovaWrapper'"
                    view['http_request'] = "http = new Http()"
                    view['token_requester'] = "@getTokenId()"
                    view['token_requester_implicit'] = "(() -> return null)"
                    view['extra_signalr_params'] = ""
                    view['signalr_default_scheme'] = 'https'
                    view['signalr_default_port'] = '443'
                    view['signalr_require'] = "SignalR = require './SignalRCordovaWrapper'"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./cordova/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()
                )
            )
        )
    )
)