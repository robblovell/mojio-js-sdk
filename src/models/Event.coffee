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
                "_deleted": "Boolean",
                "TripId": "String",
                "Altitude": "Float",
                "Heading": "Integer",
                "Distance": "Float",
                "FuelLevel": "Float",
                "FuelEfficiency": "Float",
                "Speed": "Float",
                "Acceleration": "Float",
                "Deceleration": "Float",
                "Odometer": "Float",
                "RPM": "Integer",
                "DTCs": "Array",
                "MilStatus": "Boolean",
                "Force": "Float"
            }

        super(json)
