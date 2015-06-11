(function() {
    var MojioModel, ScriptObserver, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = ScriptObserver = function(_super) {
        function ScriptObserver(json) {
            ScriptObserver.__super__.constructor.call(this, json);
        }
        __extends(ScriptObserver, _super);
        ScriptObserver.prototype._schema = {
            Script: "String",
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
        ScriptObserver.prototype._resource = "ScriptObservers";
        ScriptObserver.prototype._model = "ScriptObserver";
        ScriptObserver._resource = "ScriptObservers";
        ScriptObserver._model = "ScriptObserver";
        ScriptObserver.resource = function() {
            return ScriptObserver._resource;
        };
        ScriptObserver.model = function() {
            return ScriptObserver._model;
        };
        return ScriptObserver;
    }(MojioModel);
}).call(this);