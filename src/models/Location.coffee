MojioModel = require('./MojioModel')
module.exports = class Location extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Lat": "Float",
                "Lng": "Float",
                "FromLockedGPS": "Boolean",
                "Dilution": "Float",
                "IsValid": "Boolean"
            }

        super(json)
