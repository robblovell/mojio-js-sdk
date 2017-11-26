# @nodoc
module.exports = class SignalRRegistry
    observer_callbacks:  {}

    constructor: () ->
#        super()
        @hubs = {}

    observer_registry: (entity) =>
        # need to have the observer id to look this up here.
        # could use the entity type
        if @observer_callbacks[entity._id]
            callback(entity) for callback in @observer_callbacks[entity._id]
        else if @observer_callbacks[entity.Type]
            callback(entity) for callback in @observer_callbacks[entity.Type]

    setCallback: (id, futureCallback) ->
        if (!@observer_callbacks[id]?)
            @observer_callbacks[id] = []
        @observer_callbacks[id].push(futureCallback)
        return

    removeCallback: (id, pastCallback) ->
        if (pastCallback == null)
            @observer_callbacks[id] = []
        else
            temp = []
            # reform the obxerver_callbacks list without the given pastCallback
            for callback in @observer_callbacks[id]
                temp.push(callback) if (callback != pastCallback)
            @observer_callbacks[id] = temp
        return
