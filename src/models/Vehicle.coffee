MojioModel = require('./MojioModel')
module.exports = class Vehicle extends MojioModel
    constructor: (json) ->

        @schema =
            {
                "Type": "Integer",
                "OwnerId": "String",
                "MojioId": "String",
                "Name": "String",
                "VIN": "String",
                "LicensePlate": "String",
                "IgnitionOn": "Boolean",
                "LastTripEvent": "String",
                "LastLocationTime": "String",
                "LastLocation": "Object",
                "LastSpeed": "Float",
                "FuelLevel": "Float",
                "LastFuelEfficiency": "Float",
                "CurrentTrip": "String",
                "LastTrip": "String",
                "LastContactTime": "String",
                "MilStatus": "Boolean",
                "FaultsDetected": "Boolean",
                "Viewers": "Array",
                "_id": "String",
                "_deleted": "Boolean"
            }


        super(json)
