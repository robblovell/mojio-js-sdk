# This is the transport (play, pause, stop) functionality for the simulator

module.exports = class MojioSimulator

    constructor: (client, options) ->
        @interval = null
        @stop()
        @current = null
        @container = null
        @vehicleId = null
        @client = client
        @settings = $.extend({
            'delay': 3000,
        }, options)

    play: () =>
        if (!@interval)
            @interval = setInterval(step, @settings.delay)
        @step()

    pause: () =>
        if (@interval)
            @clearInterval(@interval)
            @interval = null

    stop: () =>
        @pause()
        # Reset
        @current = @previous = @next = null;

    step: () =>
        @send(@next())

    next: () =>
        @previous = @current;

        if (!@current)
            @current = @container.find('li').first()
            @next = @current.next()
        else
            @current = @next

        if (!@current || @current.length == 0)
            # Done!
            @stop()
        else
            @next = @current.next()

        return @current


    addVariableToObject: (el, arr, val) ->
        if (arr.length == 0)
            return val

        el = {} if (!el)
        base = arr.shift()
        el[base] = addVariableToObject(el[base], arr, val)
        return el

    loadSamples: loadSamples
    addEvent: addEvent
    importKML: importKML
    importGPX: importGPX

    getNext: () =>
        return @next
    getCurrent:  () =>
        return @current
    getPrevious: () =>
        return @previous
    setVehicleId: (id) =>
        @vehicleId = id

    onSend: (func) =>
        $(@).bind('mojioSimulatorSend', func)
        return this

    onSuccess: (func) =>
        $(@).bind('mojioSimulatorSuccess', func)
        return this

    onFail: (func) =>
        $(@).bind('mojioSimulatorFail', func)
        return this

    getState: () =>
        if (!@next)
            return 'Stopped'
        else if (@interval)
            return 'Playing'
        else
            return 'Paused'

    send: (el) =>
        vals = {}

        if (!el)
            return

        el.find('input, select').each(() ->
            input = $(@)
            sections = input.attr("name").split(".")
            addVariableToObject(vals, sections, input.val())
        )

        if (!vals.EventType)
            stop()
            return

        vals.VehicleId = _vehicleId;

        $.event.trigger('mojioSimulatorSend', [el, vals])
        @client.save("events", vals
            ).done( (data) ->
                $(@).trigger('mojioSimulatorSuccess', [el,data])
            ).fail( (data) ->
                $(@).trigger('mojioSimulatorFail', [el, data]);
            )



