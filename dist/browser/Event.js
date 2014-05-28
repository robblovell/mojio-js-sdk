!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.App=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var Event, MojioModel,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MojioModel = _dereq_('./MojioModel');

  module.exports = Event = (function(_super) {
    __extends(Event, _super);

    function Event(json) {
      this.schema = {
        "Type": "Integer",
        "MojioId": "String",
        "VehicleId": "String",
        "OwnerId": "String",
        "EventType": "Integer",
        "Time": "String",
        "Location": "Object",
        "TimeIsApprox": "Boolean",
        "BatteryVoltage": "Float",
        "ConnectionLost": "Boolean",
        "_id": "String",
        "_deleted": "Boolean",
        "TripId": "String",
        "Altitude": "Float",
        "Heading": "Integer",
        "Distance": "Float",
        "FuelLevel": "Float",
        "FuelEfficiency": "Float",
        "Speed": "Float",
        "Acceleration": "Float",
        "Deceleration": "Float",
        "Odometer": "Float",
        "RPM": "Integer",
        "DTCs": "Array",
        "MilStatus": "Boolean",
        "Force": "Float"
      };
      Event.__super__.constructor.call(this, json);
    }

    return Event;

  })(MojioModel);

}).call(this);

/*
//@ sourceMappingURL=Event.map
*/

},{"./MojioModel":2}],2:[function(_dereq_,module,exports){
// Generated by CoffeeScript 1.6.3
(function() {
  var MojioModel,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  module.exports = MojioModel = (function() {
    MojioModel.prototype.schema = {};

    function MojioModel(json) {
      this.validate = __bind(this.validate, this);
      this.get = __bind(this.get, this);
      this.set = __bind(this.set, this);
      this.validate(json);
    }

    MojioModel.prototype.set = function(field, value) {
      if ((this.schema[field] != null)) {
        return this[field] = value;
      } else {
        throw "Field '" + field + "' not in model '" + this.constructor.name + "'.";
      }
    };

    MojioModel.prototype.get = function(field) {
      return this[field];
    };

    MojioModel.prototype.validate = function(json) {
      var field, value, _results;
      _results = [];
      for (field in json) {
        value = json[field];
        _results.push(this.set(field, value));
      }
      return _results;
    };

    return MojioModel;

  })();

}).call(this);

/*
//@ sourceMappingURL=MojioModel.map
*/

},{}]},{},[1])
(1)
});