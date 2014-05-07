MojioModel = require('./MojioModel')
module.exports = class Mojio extends MojioModel
    constructor: (json) ->

        @schema =
            {
                "OwnerId": "String",
                "Name": "String",
                "Imei": "String",
                "LastContactTime": "String",
                "VehicleId": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }


        super(json)
