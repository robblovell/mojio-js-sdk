(function() {
    var AltitudeObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = AltitudeObserver = function(_super) {
        function AltitudeObserver(json) {
            AltitudeObserver.__super__.constructor.call(this, json);
        }
        __extends(AltitudeObserver, _super);
        AltitudeObserver.prototype._schema = {
            AltitudeLow: "Float",
            AltitudeHigh: "Float",
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
        AltitudeObserver.prototype._resource = "AltitudeObservers";
        AltitudeObserver.prototype._model = "AltitudeObserver";
        AltitudeObserver._resource = "AltitudeObservers";
        AltitudeObserver._model = "AltitudeObserver";
        AltitudeObserver.resource = function() {
            return AltitudeObserver._resource;
        };
        AltitudeObserver.model = function() {
            return AltitudeObserver._model;
        };
        return AltitudeObserver;
    }(MojioModel);
}).call(this);