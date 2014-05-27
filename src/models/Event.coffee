MojioModel = require('./MojioModel')
module.exports = class Event extends MojioModel
    constructor: (json) ->

        @schema =
            {
                "Type": "Integer",
                "MojioId": "String",
                "VehicleId": "String",
                "OwnerId": "String",
                "EventType": "Integer",
                "Time": "String",
                "Location": "Object",
                "TimeIsApprox": "Boolean",
                "BatteryVoltage": "Float",
                "ConnectionLost": "Boolean",
                "_id": "String",
                "_deleted": "Boolean"
            }


        super(json)
