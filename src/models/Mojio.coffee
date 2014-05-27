MojioModel = require('./MojioModel')
module.exports = class Mojio extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Type": "Integer",
                "OwnerId": "String",
                "Name": "String",
                "Imei": "String",
                "LastContactTime": "String",
                "VehicleId": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }

        super(json)
