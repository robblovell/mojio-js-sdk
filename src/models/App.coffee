MojioModel = require('./MojioModel')

module.exports = class App extends MojioModel
    # instance variables
    _schema: {
        "Type": "Integer",
        "Name": "String",
        "Description": "String",
        "CreationDate": "String",
        "Downloads": "Integer",
        "_id": "String",
        "_deleted": "Boolean"
    }

    _resource: 'Apps'
    _model: 'App'

    constructor: (json) ->
        super(json)

    observe: (children=null, callback) ->
        callback(null,null)

    storage: (property, value, callback) ->
        callback(null,null)

    statistic: (expression, callback) ->
        callback(null,null)

    # class variables and functions
    @_resource: 'Apps'
    @_model: 'App'

    @resource: () ->
        return App._resource

    @model: () ->
        return App._model

