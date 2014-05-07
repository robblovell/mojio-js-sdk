fs = require('fs')
Combyne = require('combyne')

MojioClient = require '../lib/MojioClient'
mojio = new MojioClient(
    {
        hostname: 'sandbox.api.moj.io',
        version: 'v1',
        port:'80'
    })

mojio.schema((error, result) ->
    if (error)
        console.log(error)
    else
        fs = require('fs')
        console.log(result)
        fs.writeFile('./models/schema.coffee', JSON.stringify(result,null,4), (err) ->
            if (err)
                throw err
        )

        fs.readFile('./models/ModelTemplate.mustache', (err, data) ->
            model_template = Combyne(data.toString())
            fs.readFile('../test/TestTemplate.mustache', (err, data) ->
                test_template = Combyne(data.toString())

                models = []
                i=0
                for model, schema of result

                    continue if (model == "Invoice" || model == "Product" || model == "Login")

                    view = {
                        Model: model
                        model: model.toLowerCase()
                        schema: ""
                    }

                    str = JSON.stringify(schema,null,4)
                    spl = str.split('\n')
                    for s in spl
                        view['schema'] += '            '+s+'\n'

                    output = model_template.render(view)
                    wstream = fs.createWriteStream("./models/"+model+".coffee")
                    wstream.write(output)
                    wstream.end()

                    continue if (model == "Address" || model == "Location")

                    output = test_template.render(view)
                    wstream = fs.createWriteStream("../test/"+model+"_test.coffee")
                    wstream.write(output)
                    wstream.end()
                    models[i++] = view

                fs.readFile('./MojioClientTemplate.mustache', (err, data) ->
                    client_template = Combyne(data.toString())
                    view['models'] = models
                    view['http_require'] = "Http = require './HttpMojio'"
                    view['http_request'] = "http = new Http()"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./nodejs/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()

                    view['http_require'] = "Http = require './HttpBrowser'"
                    view['http_request'] = "http = new Http($)"
                    output = client_template.render(view)

                    wstream = fs.createWriteStream("./browser/MojioClient.coffee")
                    wstream.write(output)
                    wstream.end()
                )
            )
        )
)

