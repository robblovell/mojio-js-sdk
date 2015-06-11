(function() {
    var MojioModel, SpeedObserver, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = SpeedObserver = function(_super) {
        function SpeedObserver(json) {
            SpeedObserver.__super__.constructor.call(this, json);
        }
        __extends(SpeedObserver, _super);
        SpeedObserver.prototype._schema = {
            SpeedLow: "Float",
            SpeedHigh: "Float",
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
        SpeedObserver.prototype._resource = "SpeedObservers";
        SpeedObserver.prototype._model = "SpeedObserver";
        SpeedObserver._resource = "SpeedObservers";
        SpeedObserver._model = "SpeedObserver";
        SpeedObserver.resource = function() {
            return SpeedObserver._resource;
        };
        SpeedObserver.model = function() {
            return SpeedObserver._model;
        };
        return SpeedObserver;
    }(MojioModel);
}).call(this);