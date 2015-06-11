(function() {
    var MojioModel, Observer, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Observer = function(_super) {
        function Observer(json) {
            Observer.__super__.constructor.call(this, json);
        }
        __extends(Observer, _super);
        Observer.prototype._schema = {
            Type: "String",
            Name: "String",
            ObserverType: "String",
            EventTypes: "Array",
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
        Observer.prototype._resource = "Observers";
        Observer.prototype._model = "Observer";
        Observer._resource = "Observers";
        Observer._model = "Observer";
        Observer.resource = function() {
            return Observer._resource;
        };
        Observer.model = function() {
            return Observer._model;
        };
        return Observer;
    }(MojioModel);
}).call(this);