MojioModel = require('./MojioModel')

module.exports = class Location extends MojioModel
    # instance variables
    _schema:             {
                "Lat": "Float",
                "Lng": "Float",
                "FromLockedGPS": "Boolean",
                "Dilution": "Float",
                "IsValid": "Boolean"
            }


    _resource: 'Locations'
    _model: 'Location'

    constructor: (json) ->
        super(json)

    observe: (children=null, callback) ->
        callback(null,null)

    storage: (property, value, callback) ->
        callback(null,null)

    statistic: (expression, callback) ->
        callback(null,null)

    # class variables and functions
    @_resource: 'Locations'
    @_model: 'Location'

    @resource: () ->
        return Location._resource

    @model: () ->
        return Location._model

