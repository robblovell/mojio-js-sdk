# the base class for models.
module.exports = class MojioModel
    schema: {}

    constructor: (json) ->
        @validate(json)

    set: (field, value) =>
        if (@schema[field]?)
            @[field] = value
        else
            throw "Field '"+field+"' not in model '"+@constructor.name+"'."

    get: (field) =>
        return @[field]

    validate: (json) =>
        for field, value of json
            @set(field, value)
