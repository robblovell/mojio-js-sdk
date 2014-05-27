MojioModel = require('./MojioModel')
module.exports = class Product extends MojioModel
    constructor: (json) ->
        @schema =
            {
                "Type": "Integer",
                "AppId": "String",
                "Name": "String",
                "Description": "String",
                "Shipping": "Boolean",
                "Taxable": "Boolean",
                "Price": "Float",
                "Discontinued": "Boolean",
                "OwnerId": "String",
                "CreationDate": "String",
                "_id": "String",
                "_deleted": "Boolean"
            }

        super(json)
