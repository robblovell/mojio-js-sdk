_MOJIO = require './mojio-client-crud'

module.exports = class MOJIO_APPS extends _MOJIO

    constructor: (@options) ->
        super(@options)

    ###
        Applications
    ###
    apps_resource: 'Apps'

    _applications: (callback) -> # Use if you want the raw result of the call.
        @Request({ method: 'GET', resource: @apps_resource, id: @options.application}, callback)

    # Get Applications
    applications: (callback) ->
        @_applications((error, result) => callback(error, result))