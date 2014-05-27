MojioModel = require('./MojioModel')
module.exports = class User extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Type": "Integer",
                "UserName": "String",
                "FirstName": "String",
                "LastName": "String",
                "Email": "String",
                "UserCount": "Integer",
                "Credits": "Integer",
                "CreationDate": "String",
                "LastActivityDate": "String",
                "LastLoginDate": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }

        super(json)
