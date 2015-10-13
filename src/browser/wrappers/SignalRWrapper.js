// Generated by CoffeeScript 1.9.3
(function() {
  var SignalRBrowserWrapper, SignalRRegistry, iSignalRWrapper,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  iSignalRWrapper = require('./iSignalRWrapper');

  SignalRRegistry = require('./SignalRRegistry');

  module.exports = SignalRBrowserWrapper = (function(superClass) {
    var registry;

    extend(SignalRBrowserWrapper, superClass);

    registry = new SignalRRegistry();

    function SignalRBrowserWrapper(url, hubNames1, jquery) {
      this.url = url;
      this.hubNames = hubNames1;
      this.$ = jquery;
      this.available_hubs = hubNames;
      this.signalr = null;
      this.connectionStatus = false;
      SignalRBrowserWrapper.__super__.constructor.call(this);
    }

    SignalRBrowserWrapper.prototype.getHub = function(which, callback) {
      var hub;
      if (registry.hubs[which]) {
        return callback(null, registry.hubs[which]);
      } else {
        if (this.signalr == null) {
          this.signalr = this.$.hubConnection(this.url, {
            useDefaultPath: false
          });
          this.signalr.error(function(error) {
            console.log("Connection error" + error);
            return callback(error, null);
          });
        }
        registry.hubs[which] = this.signalr.createHubProxy(which);
        hub = registry.hubs[which];
        hub.on("error", function(data) {
          return console.log("Hub '" + which + "' has error" + data);
        });
        hub.on("UpdateEntity", registry.observer_registry);
        if (hub.connection.state !== 1) {
          if (!this.connectionStatus) {
            return this.signalr.start().done((function(_this) {
              return function() {
                _this.connectionStatus = true;
                return hub.connection.start().done(function() {
                  return callback(null, hub);
                });
              };
            })(this));
          } else {
            return hub.connection.start().done((function(_this) {
              return function() {
                return callback(null, hub);
              };
            })(this));
          }
        } else {
          return callback(null, hub);
        }
      }
    };

    SignalRBrowserWrapper.prototype.subscribe = function(hubName, method, observerId, subject, futureCallback, callback) {
      registry.setCallback(subject, futureCallback);
      return this.getHub(hubName, function(error, hub) {
        if (error != null) {
          return callback(error, null);
        } else {
          if (hub != null) {
            hub.invoke(method, observerId);
          }
          return callback(null, hub);
        }
      });
    };

    SignalRBrowserWrapper.prototype.unsubscribe = function(hubName, method, observerId, subject, pastCallback, callback) {
      registry.removeCallback(subject, pastCallback);
      if (registry.observer_callbacks[subject].length === 0) {
        return this.getHub(hubName, function(error, hub) {
          if (error != null) {
            return callback(error, null);
          } else {
            if (hub != null) {
              hub.invoke(method, observerId);
            }
            return callback(null, hub);
          }
        });
      } else {
        return callback(null, true);
      }
    };

    return SignalRBrowserWrapper;

  })(iSignalRWrapper);

}).call(this);
