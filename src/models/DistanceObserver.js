(function() {
    var DistanceObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = DistanceObserver = function(_super) {
        function DistanceObserver(json) {
            DistanceObserver.__super__.constructor.call(this, json);
        }
        __extends(DistanceObserver, _super);
        DistanceObserver.prototype._schema = {
            DistanceLow: "Float",
            DistanceHigh: "Float",
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
        DistanceObserver.prototype._resource = "DistanceObservers";
        DistanceObserver.prototype._model = "DistanceObserver";
        DistanceObserver._resource = "DistanceObservers";
        DistanceObserver._model = "DistanceObserver";
        DistanceObserver.resource = function() {
            return DistanceObserver._resource;
        };
        DistanceObserver.model = function() {
            return DistanceObserver._model;
        };
        return DistanceObserver;
    }(MojioModel);
}).call(this);