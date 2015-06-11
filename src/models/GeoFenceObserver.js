(function() {
    var GeoFenceObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = GeoFenceObserver = function(_super) {
        function GeoFenceObserver(json) {
            GeoFenceObserver.__super__.constructor.call(this, json);
        }
        __extends(GeoFenceObserver, _super);
        GeoFenceObserver.prototype._schema = {
            Location: "Object",
            Radius: "Float",
            Timing: "Integer",
            Type: "Integer",
            Name: "String",
            ObserverType: "Integer",
            AppId: "String",
            OwnerId: "String",
            Parent: "String",
            ParentId: "String",
            Subject: "String",
            SubjectId: "String",
            Transports: "Integer",
            Status: "Integer",
            Tokens: "Array",
            _id: "String",
            _deleted: "Boolean"
        };
        GeoFenceObserver.prototype._resource = "GeoFenceObservers";
        GeoFenceObserver.prototype._model = "GeoFenceObserver";
        GeoFenceObserver._resource = "GeoFenceObservers";
        GeoFenceObserver._model = "GeoFenceObserver";
        GeoFenceObserver.resource = function() {
            return GeoFenceObserver._resource;
        };
        GeoFenceObserver.model = function() {
            return GeoFenceObserver._model;
        };
        return GeoFenceObserver;
    }(MojioModel);
}).call(this);