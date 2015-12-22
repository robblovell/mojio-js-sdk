MojioSDK = require("./../../src/nodejs/sdk/MojioSDK")
MojioPromiseStyle = require("./../../src/nodejs/styles/MojioPromiseStyle")
MojioAuthSDK = require('../../src/nodejs/sdk/MojioAuthSDK')

client_id = "36c80c0f-3c9d-45ac-9dab-31ea43bcc33a"
client_secret = "20ffc722-e074-4f88-b6eb-af15e72c56b3"
userPassword = '2R2nH@&K'
userName = 'kennethtestacct'
redirect_uri = "http://www.dummyurl.com/"
async = require('async')
init = {
  apiURL: 'api.moj.io'
  client_id: client_id
  client_secret: client_secret
  style: MojioPromiseStyle
  environment: "staging"
#test: true,
}

sdk = new MojioSDK(init)
printErrorOrResult = () ->
  console.log("error: "+error) if error?
  console.log("result: "+JSON.stringify(result)) if result?

async.series([
  (cb) ->
    sdk
    .token(redirect_uri)
    .credentials(userName, userPassword)
    .scope(['full'])
    .callback((error, result) ->
      if (error)
        console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
      else
        token = result
        #        sdk.parse(token)
        console.log("Token:"+JSON.stringify(token))
      cb(error, result)
    )
,
  (cb) ->
    mojios = sdk.get().mojios()
    sdk.callback((error, result) ->
      if (error)
        console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())
      else
        token = result
        console.log("Token:"+JSON.stringify(token))
      cb(error, result)
    )
,
  (cb) ->
    vehicles = sdk.get().vehicles().callback((error, result) ->
      if (error)
        console.log('Access Token Error', JSON.stringify(error.content)+"  message:"+error.statusMessage+"  url:"+sdk.url())

      else
        token = result
        console.log("Token:"+JSON.stringify(token))
      cb(error, result)
    )
],
  (error,result) ->
    printErrorOrResult(error, result)

)