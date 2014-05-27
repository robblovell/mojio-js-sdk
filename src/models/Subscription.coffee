MojioModel = require('./MojioModel')
module.exports = class Subscription extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Type": "Integer",
                "ChannelType": "Integer",
                "ChannelTarget": "String",
                "AppId": "String",
                "OwnerId": "String",
                "Event": "Integer",
                "EntityType": "Integer",
                "EntityId": "String",
                "Interval": "Integer",
                "LastMessage": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }

        super(json)
