fs = require('fs')
Combyne = require('combyne')

#MojioClient = require '../lib/MojioClient'
#mojio = new MojioClient(
#    {
#        hostname: 'api.moj.io',
#        version: 'v1',
#        port:'80'
#    })

#mojio.schema((error, result) ->
#    if (error)
#        console.log(error)
#    else
#        fs = require('fs')
#        console.log(result)
#        fs.writeFile('./models/schema.coffee', JSON.stringify(result,null,4), (err) ->
#            throw err if (err)
#
#        )

fs.readFile('./models/schema.coffee', (err, data) ->
    throw err if (err)

    result = JSON.parse(data)

    fs.readFile('./models/ModelTemplate.mustache', (err, data) ->
        model_template = Combyne(data.toString())
        fs.readFile('../test/TestTemplate.mustache', (err, data) ->
            test_template = Combyne(data.toString())
            models = []
            i=0
            for model, schema of result

                continue if (model != "App" && model != "Address" && model != "Location" && model != "Trip" &&
                    model != "User" && model != "Vehicle"  && model != "Event" && model != "Mojio" &&
                    model != "Observer" && model != "Subscription" && model != "Product")

                view = {
                    Model: model
                    model: model.toLowerCase()
                    schema: ""
                }

                console.log("Processing "+model)
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

                continue if (model == "Address" || model == "Location" || model == "Observer")

                output = test_template.render(view)
                wstream = fs.createWriteStream("../test/"+model+"_test.coffee")
                wstream.write(output)
                wstream.end()
                models[i++] = view

            fs.readFile('./MojioClientTemplate.mustache', (err, data) ->
                client_template = Combyne(data.toString())
                view['models'] = models
                view['http_require'] = "Http = require './HttpNodeWrapper'"
                view['http_request'] = "http = new Http()"
                output = client_template.render(view)

                wstream = fs.createWriteStream("./nodejs/MojioClient.coffee")
                wstream.write(output)
                wstream.end()

                view['http_require'] = "Http = require './HttpBrowserWrapper'"
                view['http_request'] = "http = new Http($)"
                output = client_template.render(view)

                wstream = fs.createWriteStream("./browser/MojioClient.coffee")
                wstream.write(output)
                wstream.end()
            )
        )
    )
)