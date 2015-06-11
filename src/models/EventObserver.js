(function() {
    var EventObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = EventObserver = function(_super) {
        function EventObserver(json) {
            EventObserver.__super__.constructor.call(this, json);
        }
        __extends(EventObserver, _super);
        EventObserver.prototype._schema = {
            EventTypes: "Array",
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
        EventObserver.prototype._resource = "EventObservers";
        EventObserver.prototype._model = "EventObserver";
        EventObserver._resource = "EventObservers";
        EventObserver._model = "EventObserver";
        EventObserver.resource = function() {
            return EventObserver._resource;
        };
        EventObserver.model = function() {
            return EventObserver._model;
        };
        return EventObserver;
    }(MojioModel);
}).call(this);