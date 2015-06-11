(function() {
    var DiagnosticCodeObserver, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = DiagnosticCodeObserver = function(_super) {
        function DiagnosticCodeObserver(json) {
            DiagnosticCodeObserver.__super__.constructor.call(this, json);
        }
        __extends(DiagnosticCodeObserver, _super);
        DiagnosticCodeObserver.prototype._schema = {
            DiagnosticCodes: "Array",
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
        DiagnosticCodeObserver.prototype._resource = "DiagnosticCodeObservers";
        DiagnosticCodeObserver.prototype._model = "DiagnosticCodeObserver";
        DiagnosticCodeObserver._resource = "DiagnosticCodeObservers";
        DiagnosticCodeObserver._model = "DiagnosticCodeObserver";
        DiagnosticCodeObserver.resource = function() {
            return DiagnosticCodeObserver._resource;
        };
        DiagnosticCodeObserver.model = function() {
            return DiagnosticCodeObserver._model;
        };
        return DiagnosticCodeObserver;
    }(MojioModel);
}).call(this);