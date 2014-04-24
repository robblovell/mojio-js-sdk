_MOJIO = require './mojio-client-apps'

module.exports = class MOJIO_EVENTS extends _MOJIO

    constructor: (@options) ->
        super(@options)

    ###
        Events
    ###
    events_resource: 'Events'

    _events: (callback) -> # Use if you want the raw result of the call.
        @Request({ method: 'GET', resource: @events_resource }, callback)

    # Get Applications
    events: (callback) ->
        @_events((error, result) => callback(error, result))