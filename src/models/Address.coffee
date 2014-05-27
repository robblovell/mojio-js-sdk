MojioModel = require('./MojioModel')
module.exports = class Address extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Address1": "String",
                "Address2": "String",
                "City": "String",
                "State": "String",
                "Zip": "String",
                "Country": "String"
            }

        super(json)
