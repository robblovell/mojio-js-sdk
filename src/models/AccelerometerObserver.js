(function() {
    var AccelerometerObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = AccelerometerObserver = function(_super) {
        function AccelerometerObserver(json) {
            AccelerometerObserver.__super__.constructor.call(this, json);
        }
        __extends(AccelerometerObserver, _super);
        AccelerometerObserver.prototype._schema = {
            AccelerometerLow: "Object",
            AccelerometerHigh: "Object",
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
        AccelerometerObserver.prototype._resource = "AccelerometerObservers";
        AccelerometerObserver.prototype._model = "AccelerometerObserver";
        AccelerometerObserver._resource = "AccelerometerObservers";
        AccelerometerObserver._model = "AccelerometerObserver";
        AccelerometerObserver.resource = function() {
            return AccelerometerObserver._resource;
        };
        AccelerometerObserver.model = function() {
            return AccelerometerObserver._model;
        };
        return AccelerometerObserver;
    }(MojioModel);
}).call(this);