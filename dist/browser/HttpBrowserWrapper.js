(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.HttpBrowserWrapper = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"/HttpBrowserWrapper.js":[function(require,module,exports){
// Generated by CoffeeScript 2.0.2
(function() {
  var HttpBrowserWrapper;

  module.exports = HttpBrowserWrapper = class HttpBrowserWrapper {
    constructor(requester = null) {
      if (requester != null) {
        this.requester = requester;
      }
    }

    request(params, callback) {
      var k, ref, url, v, xmlhttp;
      if (params.method == null) {
        params.method = "GET";
      }
      if ((params.host == null) && (params.hostname != null)) {
        params.host = params.hostname;
      }
      if (!((params.scheme != null) || (typeof window === "undefined" || window === null))) {
        params.scheme = window.location.protocol.split(':')[0];
      }
      if (!params.scheme || params.scheme === 'file') {
        params.scheme = 'https';
      }
      if (params.data == null) {
        params.data = {};
      }
      if (params.body != null) {
        params.data = params.body;
      }
      if (params.headers == null) {
        params.headers = {};
      }
      url = params.scheme + "://" + params.hostname + ":" + params.port + params.path;
      if (params.method === "GET" && (params.data != null) && params.data.length > 0) {
        url += '?' + Object.keys(params.data).map(function(k) {
          return encodeURIComponent(k) + '=' + encodeURIComponent(params.data[k]);
        }).join('&');
      }
      if ((typeof XMLHttpRequest !== "undefined" && XMLHttpRequest !== null)) {
        xmlhttp = new XMLHttpRequest;
      } else {
        xmlhttp = this.requester;
      }
      xmlhttp.open(params.method, url, true);
      ref = params.headers;
      for (k in ref) {
        v = ref[k];
        xmlhttp.setRequestHeader(k, v);
      }
      xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState === 4) {
          if (xmlhttp.status >= 200 && xmlhttp.status <= 299) {
            return callback(null, JSON.parse(xmlhttp.responseText));
          } else {
            return callback(xmlhttp.statusText, null);
          }
        }
      };
      if (params.method === "GET") {
        return xmlhttp.send();
      } else {
        return xmlhttp.send(params.data);
      }
    }

    redirect(params, callback) { // callback is through a server call.
      var url;
      url = params.scheme + "://" + params.hostname + ":" + params.port + params.path;
      return window.location = url;
    }

  };

}).call(this);

},{}]},{},[])("/HttpBrowserWrapper.js")
});