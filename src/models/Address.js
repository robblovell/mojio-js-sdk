(function() {
    var Address, MojioModel, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Address = function(_super) {
        function Address(json) {
            Address.__super__.constructor.call(this, json);
        }
        __extends(Address, _super);
        Address.prototype._schema = {
            Address1: "String",
            Address2: "String",
            City: "String",
            State: "String",
            Zip: "String",
            Country: "String"
        };
        Address.prototype._resource = "Addresss";
        Address.prototype._model = "Address";
        Address._resource = "Addresss";
        Address._model = "Address";
        Address.resource = function() {
            return Address._resource;
        };
        Address.model = function() {
            return Address._model;
        };
        return Address;
    }(MojioModel);
}).call(this);