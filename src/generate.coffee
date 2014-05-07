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
        for model, schema of result
            continue if (model == "Invoice" || model == "Product" || model == "Login")
            fs = require('fs');
            # write the models.
            wstream = fs.createWriteStream("./models/"+model+'.coffee')
            wstream.write("Model = require('./MojioModel')\n")
            wstream.write("module.exports = class "+model+" extends  Model\n")
            wstream.write("    constructor: (json) ->\n")
            wstream.write("        @schema = \n")
            str = JSON.stringify(schema,null,4)
            spl = str.split('\n')
            for s in spl
                wstream.write('            '+s+'\n')
            wstream.write("        super(json)\n")
            wstream.end()
            continue if (model == "Address" || model == "Location")

            # write the tests.
            wstream = fs.createWriteStream('../test/'+model+'_test.coffee')
            wstream.write("MojioClient = require '../lib/MojioClient'\n")
            wstream.write(model+" = require '../src/models/"+model+"'\n")
            wstream.write("config = require './config/mojio-config.coffee'\n")

            wstream.write("mojio_client = new MojioClient(config)\n")

            wstream.write("assert = require('assert')\n")
            wstream.write("testdata = require('./data/mojio-test-data')\n")
            wstream.write("should = require('should')\n")

            wstream.write("describe '"+model+"', ->\n")
            wstream.write("    it 'can get "+model+"', (done) ->\n")
            wstream.write("        mojio_client.login(testdata.username, testdata.password, (error, result) ->\n")
            wstream.write("            (error==null).should.be.true\n")
            wstream.write("            mojio_client."+model.toLowerCase()+"s((error, result) ->\n")
            wstream.write("                (error==null).should.be.true\n")
            wstream.write("                mojio_client.should.be.an.instanceOf(MojioClient)\n")
            wstream.write("                if (result.Data instanceof Array)\n")
            wstream.write("                    "+model.toLowerCase()+" = new "+model+"(result.Data[0])\n")
            wstream.write("                else if (result.Data?)\n")
            wstream.write("                    "+model.toLowerCase()+" = new "+model+"(result.Data)\n")
            wstream.write("                else\n")
            wstream.write("                    "+model.toLowerCase()+" = new "+model+"(result)\n")
            wstream.write("                "+model.toLowerCase()+".should.be.an.instanceOf("+model+")\n")
            wstream.write("                done()\n")
            wstream.write("            )\n")
            wstream.write("        )\n")
            wstream.end()

)