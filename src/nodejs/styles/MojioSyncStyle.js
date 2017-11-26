// Generated by CoffeeScript 1.12.7
(function() {
  var MojioSyncStyle, wait,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  wait = require('wait.for');

  module.exports = MojioSyncStyle = (function() {
    function MojioSyncStyle() {
      this.sync = bind(this.sync, this);
    }

    MojioSyncStyle.prototype.sync = function() {
      var result;
      console.log('fiber start');
      result = wait["for"](this.stateMachine.initiate);
      console.log('function returned:', result);
      console.log('fiber end');
      return result;
    };

    return MojioSyncStyle;

  })();

}).call(this);

//# sourceMappingURL=MojioSyncStyle.js.map
