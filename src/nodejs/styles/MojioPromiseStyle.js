// Generated by CoffeeScript 1.10.0
(function() {
  var MojioPromiseStyle, Promise;

  Promise = require('promise');

  module.exports = MojioPromiseStyle = (function() {
    function MojioPromiseStyle() {}

    MojioPromiseStyle.prototype.promise = function() {
      var promise;
      promise = new Promise((function(_this) {
        return function(resolve, reject) {
          return _this.stateMachine.initiate(function(error, result) {
            if (result != null) {
              resolve(result);
            }
            if (error != null) {
              return reject(error);
            }
          });
        };
      })(this));
      return promise;
    };

    return MojioPromiseStyle;

  })();

}).call(this);

//# sourceMappingURL=MojioPromiseStyle.js.map
