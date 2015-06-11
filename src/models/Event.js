(function() {
    var Event, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
        function ctor() {
            this.constructor = child;
        }
        for (var key in parent) __hasProp.call(parent, key) && (child[key] = parent[key]);
        ctor.prototype = parent.prototype;
        child.prototype = new ctor();
        child.__super__ = parent.prototype;
        return child;
    };
    MojioModel = require("./MojioModel");
    module.exports = Event = function(_super) {
        function Event(json) {
            Event.__super__.constructor.call(this, json);
        }
        __extends(Event, _super);
        Event.prototype._schema = {
            Type: "Integer",
            MojioId: "String",
            VehicleId: "String",
            OwnerId: "String",
            EventType: "Integer",
            Time: "String",
            Location: "Object",
            Accelerometer: "Object",
            TimeIsApprox: "Boolean",
            BatteryVoltage: "Float",
            ConnectionLost: "Boolean",
            _id: "String",
            _deleted: "Boolean",
            TripId: "String",
            Altitude: "Float",
            Heading: "Float",
            Distance: "Float",
            FuelLevel: "Float",
            FuelEfficiency: "Float",
            Speed: "Float",
            Acceleration: "Float",
            Deceleration: "Float",
            Odometer: "Float",
            RPM: "Integer",
            DTCs: "Array",
            MilStatus: "Boolean",
            Force: "Float",
            MaxSpeed: "Float",
            AverageSpeed: "Float",
            MovingTime: "Float",
            IdleTime: "Float",
            StopTime: "Float",
            MaxRPM: "Float",
            EventTypes: "Array",
            Timing: "Integer",
            Name: "String",
            ObserverType: "Integer",
            AppId: "String",
            Parent: "String",
            ParentId: "String",
            Subject: "String",
            SubjectId: "String",
            Transports: "Integer",
            Status: "Integer",
            Tokens: "Array"
        };
        Event.prototype._resource = "Events";
        Event.prototype._model = "Event";
        Event._resource = "Events";
        Event._model = "Event";
        Event.resource = function() {
            return Event._resource;
        };
        Event.model = function() {
            return Event._model;
        };
        return Event;
    }(MojioModel);
}).call(this);