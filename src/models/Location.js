(function() {
    var Location, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Location = function(_super) {
        function Location(json) {
            Location.__super__.constructor.call(this, json);
        }
        __extends(Location, _super);
        Location.prototype._schema = {
            Lat: "Float",
            Lng: "Float",
            FromLockedGPS: "Boolean",
            Dilution: "Float",
            IsValid: "Boolean"
        };
        Location.prototype._resource = "Locations";
        Location.prototype._model = "Location";
        Location._resource = "Locations";
        Location._model = "Location";
        Location.resource = function() {
            return Location._resource;
        };
        Location.model = function() {
            return Location._model;
        };
        return Location;
    }(MojioModel);
}).call(this);