(function() {
    var MojioModel, RPMObserver, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = RPMObserver = function(_super) {
        function RPMObserver(json) {
            RPMObserver.__super__.constructor.call(this, json);
        }
        __extends(RPMObserver, _super);
        RPMObserver.prototype._schema = {
            RpmLow: "Float",
            RpmHigh: "Float",
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
        RPMObserver.prototype._resource = "RPMObservers";
        RPMObserver.prototype._model = "RPMObserver";
        RPMObserver._resource = "RPMObservers";
        RPMObserver._model = "RPMObserver";
        RPMObserver.resource = function() {
            return RPMObserver._resource;
        };
        RPMObserver.model = function() {
            return RPMObserver._model;
        };
        return RPMObserver;
    }(MojioModel);
}).call(this);