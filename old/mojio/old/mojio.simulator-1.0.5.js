// This is the transport (play, pause, stop) functionality for the simulator

(function ($) {
    Mojio.Simulator = function (client, options) {
        var _this = this;
        var settings;

        var _mojioId;

        var _interval;

        var _previous;
        var _current;
        var _next;

        var init = function (options) {
            settings = $.extend({
                'delay': 3000,
            }, options);
        }

        function play() {
            if (!_interval)
                _interval = setInterval(step, settings.delay);

            step();
        }

        function pause() {
            if (_interval) {
                clearInterval(_interval);
                _interval = null;
            }
        }

        function stop(){
            pause();

            // Reset
            _current = _previous = _next = null;
        }

        function step() {
            send(next());
        }

        function next() {
            _previous = _current;

            if (!_current) {
                _current = _container.find('li').first();
                _next = _current.next();
            } else {
                _current = _next;
            }

            if (!_current || _current.length == 0) {
                // Done!
                stop();
            } else {
                _next = _current.next();
            }

            return _current;
        }

        function addVariableToObject(el, arr, val) {
            if (arr.length == 0)
                return val;

            if (!el) el = {};
            var base = arr.shift();
            el[base] = addVariableToObject(el[base], arr, val);
            return el;
        }

        function send(el) {
            var vals = {};

            if (!el) {
                return;
            }

            el.find('input, select').each(function () {
                var input = $(this);
                var sections = input.attr("name").split(".");
                addVariableToObject(vals, sections, input.val());
            });

            if (!vals.EventType) {
                stop();
                return;
            }

            vals.VehicleId = _vehicleId;

            $.event.trigger('mojioSimulatorSend', [el, vals]);
            client.save("events", vals).done(function(data)
            {
                $(_this).trigger('mojioSimulatorSuccess', [el,data]);
            }).fail(function (data) {
                $(_this).trigger('mojioSimulatorFail', [el, data]);
            });
        }

        init(options);

        var public = {
            loadSamples: loadSamples,
            addEvent: addEvent,
            play: play,
            stop: stop,
            step: step,
            pause: pause,
            getNext: function () { return _next; },
            getCurrent: function () { return _current; },
            getPrevious: function () { return _previous; },
            setVehicleId: function (id) { _vehicleId = id },
            onSend: function (func) {
                $(_this).bind('mojioSimulatorSend', func);
                return this;
            },
            onSuccess: function(func){
                $(_this).bind('mojioSimulatorSuccess', func);
                return this;
            },
            onFail: function (func) {
                $(_this).bind('mojioSimulatorFail', func);
                return this;
            },
            getState: function(){
                if (!_next)
                    return 'Stopped';
                else if (_interval)
                    return 'Playing';
                else
                    return 'Paused';
            },
            importKML: importKML,
            importGPX: importGPX
        };

        return public;
    }
    
})(jQuery);
