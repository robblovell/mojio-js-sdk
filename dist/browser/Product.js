(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.Product = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"/Product.js":[function(require,module,exports){
// Generated by CoffeeScript 2.0.2
(function() {
  var MojioModel, Product;

  MojioModel = require('./MojioModel');

  module.exports = Product = (function() {
    class Product extends MojioModel {
      constructor(json) {
        super(json);
      }

      static resource() {
        return Product._resource;
      }

      static model() {
        return Product._model;
      }

    };

    // instance variables
    Product.prototype._schema = {
      "Type": "String",
      "AppId": "String",
      "Name": "String",
      "Description": "String",
      "Shipping": "Boolean",
      "Taxable": "Boolean",
      "Price": "Float",
      "Discontinued": "Boolean",
      "OwnerId": "String",
      "CreationDate": "String",
      "_id": "String",
      "_deleted": "Boolean"
    };

    Product.prototype._resource = 'Products';

    Product.prototype._model = 'Product';

    // class variables and functions
    Product._resource = 'Products';

    Product._model = 'Product';

    return Product;

  })();

}).call(this);

},{"./MojioModel":1}],1:[function(require,module,exports){
// Generated by CoffeeScript 2.0.2
(function() {
  // the base class for models.
  var MojioModel;

  module.exports = MojioModel = (function() {
    class MojioModel {
      constructor(json) {
        this._client = null;
        this.validate(json);
      }

      setField(field, value) {
        //        if (@schema()[field]? || typeof value == "function")
        this[field] = value;
        return this[field];
      }

      //        unless (field=="_client" || field=="_schema" || field == "_resource" || field == "_model" ||
      //                field=="_AuthenticationType" || field=="AuthenticationType" ||
      //                field=="_IsAuthenticated" || field=="IsAuthenticated")
      //            throw "Field '"+field+"' not in model '"+@constructor.name+"'."
      getField(field) {
        return this[field];
      }

      validate(json) {
        var field, results, value;
        results = [];
        for (field in json) {
          value = json[field];
          results.push(this.setField(field, value));
        }
        return results;
      }

      // TODO:: make it so that stringify doesn't have to be used to make a saveable json string.
      //    toJSON: () ->
      //        object = {}
      //        object[key] = @[key] for key, value of @schema()
      //        return object
      stringify() {
        return JSON.stringify(this, this.replacer);
      }

      replacer(key, value) {
        if (key === "_client" || key === "_schema" || key === "_resource" || key === "_model") {
          return void 0;
        } else {
          return value;
        }
      }

      // instance methods.
      // GET
      query(criteria, callback) {
        var property, query_criteria, value;
        if (this._client === null) {
          callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
          return;
        }
        if (criteria instanceof Object) {
          if (criteria.criteria == null) {
            query_criteria = "";
            for (property in criteria) {
              value = criteria[property];
              query_criteria += `${property}=${value};`;
            }
            criteria = {
              criteria: query_criteria
            };
          }
          return this._client.request({
            method: 'GET',
            resource: this.resource(),
            parameters: criteria
          }, (error, result) => {
            return callback(error, this._client.model(this.model(), result));
          });
        } else if (typeof criteria === "string") { // instanceof only works for coffeescript classes.
          return this._client.request({
            method: 'GET',
            resource: this.resource(),
            parameters: {
              id: criteria
            }
          }, (error, result) => {
            return callback(error, this._client.model(this.model(), result));
          });
        } else {
          return callback("criteria given is not in understood format, string or object.", null);
        }
      }

      get(criteria, callback) {
        return this.query(criteria, callback);
      }

      // POST
      create(callback) {
        if (this._client === null) {
          callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
          return;
        }
        return this._client.request({
          method: 'POST',
          resource: this.resource(),
          body: this.stringify()
        }, callback);
      }

      post(callback) {
        return this.create(callback);
      }

      // PUT
      save(callback) {
        if (this._client === null) {
          callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
          return;
        }
        return this._client.request({
          method: 'PUT',
          resource: this.resource(),
          body: this.stringify(),
          parameters: {
            id: this._id
          }
        }, callback);
      }

      put(callback) {
        return this.save(callback);
      }

      // DELETE
      delete(callback) {
        return this._client.request({
          method: 'DELETE',
          resource: this.resource(),
          parameters: {
            id: this._id
          }
        }, callback);
      }

      // OBSERVER
      observe(parent = null, observer_callback, callback, options) {
        if ((parent != null)) {
          return this._client.observe(this.resource, parent, observer_callback, callback, options = {});
        } else {
          return this._client.observe(this, null, observer_callback, callback, options);
        }
      }

      unobserve(parent = null, observer_callback, callback) {
        if ((parent != null)) {
          return this._client.unobserve(this.resource, parent, observer_callback, callback);
        } else {
          return this._client.unobserve(this, null, observer_callback, callback);
        }
      }

      // STORAGE
      store(model, key, value, callback) {
        return this._client.store(model, key, value, callback);
      }

      storage(model, key, callback) {
        return this._client.storage(model, key, callback);
      }

      unstore(model, key, callback) {
        return this._client.unstore(model, key, callback);
      }

      // Unimplemented
      statistic(expression, callback) {
        return callback(null, true);
      }

      // Gettors
      resource() {
        return this._resource;
      }

      model() {
        return this._model;
      }

      schema() {
        return this._schema;
      }

      authorization(client) {
        this._client = client;
        return this;
      }

      id() {
        return this._id;
      }

      mock(type, withid = false) {
        var field, ref, value;
        ref = this.schema();
        for (field in ref) {
          value = ref[field];
          if (field === "Type") {
            this.setField(field, this.model());
          } else if (field === "UserName") {
            this.setField(field, "Tester");
          } else if (field === "Email") {
            this.setField(field, "test@moj.io");
          } else if (field === "Password") {
            this.setField(field, "Password007!");
          } else if (field !== '_id' || withid) {
            switch (value) {
              case "Integer":
                this.setField(field, "0");
                break;
              case "Boolean":
                this.setField(field, false);
                break;
              case "String":
                this.setField(field, "test" + Math.random());
            }
          }
        }
        return this;
      }

    };

    MojioModel._resource = 'Schema';

    MojioModel._model = 'Model';

    return MojioModel;

  })();

}).call(this);

},{}]},{},[])("/Product.js")
});