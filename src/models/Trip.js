(function() {
    var MojioModel, Trip, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Trip = function(_super) {
        function Trip(json) {
            Trip.__super__.constructor.call(this, json);
        }
        __extends(Trip, _super);
        Trip.prototype._schema = {
            Type: "Integer",
            MojioId: "String",
            VehicleId: "String",
            StartTime: "String",
            LastUpdatedTime: "String",
            EndTime: "String",
            MaxSpeed: "Float",
            MaxAcceleration: "Float",
            MaxDeceleration: "Float",
            MaxRPM: "Integer",
            FuelLevel: "Float",
            FuelEfficiency: "Float",
            Distance: "Float",
            StartLocation: "Object",
            LastKnownLocation: "Object",
            EndLocation: "Object",
            StartAddress: "Object",
            EndAddress: "Object",
            ForcefullyEnded: "Boolean",
            StartMilage: "Float",
            EndMilage: "Float",
            StartOdometer: "Float",
            _id: "String",
            _deleted: "Boolean"
        };
        Trip.prototype._resource = "Trips";
        Trip.prototype._model = "Trip";
        Trip._resource = "Trips";
        Trip._model = "Trip";
        Trip.resource = function() {
            return Trip._resource;
        };
        Trip.model = function() {
            return Trip._model;
        };
        return Trip;
    }(MojioModel);
}).call(this);