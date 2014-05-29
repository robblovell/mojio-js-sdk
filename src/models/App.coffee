MojioModel = require('./MojioModel')
module.exports = class App extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Type": "Integer",
                "Name": "String",
                "Description": "String",
                "CreationDate": "String",
                "Downloads": "Integer",
                "_id": "String",
                "_deleted": "Boolean"
            }

        super(json)