(function() {
    var MojioModel, Product, __hasProp = {}.hasOwnProperty, __extends = function(child, parent) {
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
    module.exports = Product = function(_super) {
        function Product(json) {
            Product.__super__.constructor.call(this, json);
        }
        __extends(Product, _super);
        Product.prototype._schema = {
            Type: "String",
            AppId: "String",
            Name: "String",
            Description: "String",
            Shipping: "Boolean",
            Taxable: "Boolean",
            Price: "Float",
            Discontinued: "Boolean",
            OwnerId: "String",
            CreationDate: "String",
            _id: "String",
            _deleted: "Boolean"
        };
        Product.prototype._resource = "Products";
        Product.prototype._model = "Product";
        Product._resource = "Products";
        Product._model = "Product";
        Product.resource = function() {
            return Product._resource;
        };
        Product.model = function() {
            return Product._model;
        };
        return Product;
    }(MojioModel);
}).call(this);