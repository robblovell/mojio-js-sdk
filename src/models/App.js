(function() {
    var App, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = App = function(_super) {
        function App(json) {
            App.__super__.constructor.call(this, json);
        }
        __extends(App, _super);
        App.prototype._schema = {
            Type: "String",
            Name: "String",
            Description: "String",
            CreationDate: "String",
            Downloads: "Integer",
            RedirectUris: "String",
            ApplicationType: "String",
            _id: "String",
            _deleted: "Boolean"
        };
        App.prototype._resource = "Apps";
        App.prototype._model = "App";
        App._resource = "Apps";
        App._model = "App";
        App.resource = function() {
            return App._resource;
        };
        App.model = function() {
            return App._model;
        };
        return App;
    }(MojioModel);
}).call(this);