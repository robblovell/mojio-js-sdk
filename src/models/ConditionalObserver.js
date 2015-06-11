(function() {
    var ConditionalObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = ConditionalObserver = function(_super) {
        function ConditionalObserver(json) {
            ConditionalObserver.__super__.constructor.call(this, json);
        }
        __extends(ConditionalObserver, _super);
        ConditionalObserver.prototype._schema = {
            Field: "String",
            Threshold1: "Float",
            Threshold2: "Float",
            Operator1: "String",
            Operator2: "String",
            Conjunction: "String",
            ConditionValue: "Boolean",
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
        ConditionalObserver.prototype._resource = "ConditionalObservers";
        ConditionalObserver.prototype._model = "ConditionalObserver";
        ConditionalObserver._resource = "ConditionalObservers";
        ConditionalObserver._model = "ConditionalObserver";
        ConditionalObserver.resource = function() {
            return ConditionalObserver._resource;
        };
        ConditionalObserver.model = function() {
            return ConditionalObserver._model;
        };
        return ConditionalObserver;
    }(MojioModel);
}).call(this);