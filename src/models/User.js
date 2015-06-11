(function() {
    var MojioModel, User, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = User = function(_super) {
        function User(json) {
            User.__super__.constructor.call(this, json);
        }
        __extends(User, _super);
        User.prototype._schema = {
            Type: "Integer",
            UserName: "String",
            FirstName: "String",
            LastName: "String",
            Email: "String",
            UserCount: "Integer",
            Credits: "Integer",
            CreationDate: "String",
            LastActivityDate: "String",
            LastLoginDate: "String",
            Locale: "String",
            _id: "String",
            _deleted: "Boolean"
        };
        User.prototype._resource = "Users";
        User.prototype._model = "User";
        User._resource = "Users";
        User._model = "User";
        User.resource = function() {
            return User._resource;
        };
        User.model = function() {
            return User._model;
        };
        return User;
    }(MojioModel);
}).call(this);