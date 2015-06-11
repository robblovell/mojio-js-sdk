(function() {
    var Mojio, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Mojio = function(_super) {
        function Mojio(json) {
            Mojio.__super__.constructor.call(this, json);
        }
        __extends(Mojio, _super);
        Mojio.prototype._schema = {
            Type: "Integer",
            OwnerId: "String",
            Name: "String",
            Imei: "String",
            LastContactTime: "String",
            VehicleId: "String",
            _id: "String",
            _deleted: "Boolean"
        };
        Mojio.prototype._resource = "Mojios";
        Mojio.prototype._model = "Mojio";
        Mojio._resource = "Mojios";
        Mojio._model = "Mojio";
        Mojio.resource = function() {
            return Mojio._resource;
        };
        Mojio.model = function() {
            return Mojio._model;
        };
        return Mojio;
    }(MojioModel);
}).call(this);