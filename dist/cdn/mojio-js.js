(function(f) {
    if (typeof exports === "object" && typeof module !== "undefined") {
        module.exports = f();
    } else if (typeof define === "function" && define.amd) {
        define([], f);
    } else {
        var g;
        if (typeof window !== "undefined") {
            g = window;
        } else if (typeof global !== "undefined") {
            g = global;
        } else if (typeof self !== "undefined") {
            g = self;
        } else {
            g = this;
        }
        g.MojioClient = f();
    }
})(function() {
    var define, module, exports;
    return function e(t, n, r) {
        function s(o, u) {
            if (!n[o]) {
                if (!t[o]) {
                    var a = typeof require == "function" && require;
                    if (!u && a) return a(o, !0);
                    if (i) return i(o, !0);
                    var f = new Error("Cannot find module '" + o + "'");
                    throw f.code = "MODULE_NOT_FOUND", f;
                }
                var l = n[o] = {
                    exports: {}
                };
                t[o][0].call(l.exports, function(e) {
                    var n = t[o][1][e];
                    return s(n ? n : e);
                }, l, l.exports, e, t, n, r);
            }
            return n[o].exports;
        }
        var i = typeof require == "function" && require;
        for (var o = 0; o < r.length; o++) s(r[o]);
        return s;
    }({
        "/MojioClient.js": [ function(require, module, exports) {
            (function() {
                var FormUrlencoded, Http, MojioClient, SignalR;
                Http = require("./HttpBrowserWrapper");
                SignalR = require("./SignalRBrowserWrapper");
                FormUrlencoded = require("form-urlencoded");
                module.exports = MojioClient = function() {
                    var App, Event, Login, Mojio, Observer, Product, Subscription, Trip, User, Vehicle, defaults, mojio_models;
                    class MojioClient {
                        constructor(options) {
                            var base, base1, base2, base3, base4, base5, base6, base7, base8, base9;
                            this.options = options;
                            if (this.options == null) {
                                this.options = {
                                    hostname: this.defaults.hostname,
                                    port: this.defaults.port,
                                    version: this.defaults.version,
                                    scheme: this.defaults.scheme,
                                    live: this.defaults.live
                                };
                            }
                            if ((base = this.options).hostname == null) {
                                base.hostname = defaults.hostname;
                            }
                            if ((base1 = this.options).authUrl == null) {
                                base1.authUrl = defaults.authUrl;
                            }
                            if ((base2 = this.options).port == null) {
                                base2.port = defaults.port;
                            }
                            if ((base3 = this.options).version == null) {
                                base3.version = defaults.version;
                            }
                            if ((base4 = this.options).scheme == null) {
                                base4.scheme = defaults.scheme;
                            }
                            if ((base5 = this.options).signalr_port == null) {
                                base5.signalr_port = defaults.signalr_port;
                            }
                            if ((base6 = this.options).signalr_scheme == null) {
                                base6.signalr_scheme = defaults.signalr_scheme;
                            }
                            if ((base7 = this.options).signalr_hub == null) {
                                base7.signalr_hub = defaults.signalr_hub;
                            }
                            this.options.observerTransport = "SingalR";
                            this.conn = null;
                            this.hub = null;
                            this.connStatus = null;
                            this.setToken(null);
                            if ((base8 = this.options).tokenRequester == null) {
                                base8.tokenRequester = function() {
                                    return document.location.hash.match(/access_token=([0-9a-f-]{36})/);
                                };
                            }
                            if ((base9 = this.options).tokenRequesterImplicit == null) {
                                base9.tokenRequesterImplicit = function() {
                                    return document.location.hash.match(/access_token=([0-9a-f-].+?)&/);
                                };
                            }
                            this.signalr = new SignalR(this.options.signalr_scheme + "://" + this.options.hostname + ":" + this.options.signalr_port + "/v1/signalr", [ this.options.signalr_hub ], $);
                        }
                        getResults(type, results) {
                            var arrlength, i, j, len, len1, objects, ref, result;
                            objects = [];
                            if (results instanceof Array) {
                                arrlength = results.length;
                                for (i = 0, len = results.length; i < len; i++) {
                                    result = results[i];
                                    objects.push(new type(result));
                                }
                            } else if (results.Data instanceof Array) {
                                arrlength = results.Data.length;
                                ref = results.Data;
                                for (j = 0, len1 = ref.length; j < len1; j++) {
                                    result = ref[j];
                                    objects.push(new type(result));
                                }
                            } else if (result.Data !== null) {
                                objects.push(new type(result.Data));
                            } else {
                                objects.push(new type(result));
                            }
                            return objects;
                        }
                        static _makeParameters(params) {
                            var property, query, value;
                            if (params.length === 0) {
                                "";
                            }
                            query = "?";
                            for (property in params) {
                                value = params[property];
                                query += `${encodeURIComponent(property)}=${encodeURIComponent(value)}&`;
                            }
                            return query.slice(0, -1);
                        }
                        getPath(resource, id, action, key) {
                            if (key && id && action && id !== "" && action !== "") {
                                return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action) + "/" + encodeURIComponent(key);
                            } else if (id && action && id !== "" && action !== "") {
                                return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id) + "/" + encodeURIComponent(action);
                            } else if (id && id !== "") {
                                return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(id);
                            } else if (action && action !== "") {
                                return "/" + encodeURIComponent(resource) + "/" + encodeURIComponent(action);
                            }
                            return "/" + encodeURIComponent(resource);
                        }
                        dataByMethod(data, method) {
                            switch (method.toUpperCase()) {
                              case "POST" || "PUT":
                                return this.stringify(data);

                              default:
                                return data;
                            }
                        }
                        stringify(data) {
                            return JSON.stringify(data);
                        }
                        request(request, callback, isOauth = false) {
                            var http, parts;
                            if (isOauth === null) {
                                isOauth = false;
                            }
                            parts = {
                                hostname: this.options.hostname,
                                port: this.options.port,
                                scheme: this.options.scheme,
                                path: isOauth ? "" : "/" + this.options.version,
                                method: request.method,
                                withCredentials: false
                            };
                            if (isOauth) {
                                parts.hostname = this.options.authUrl;
                            }
                            parts.host = parts.hostbame;
                            parts.path = parts.path + this.getPath(request.resource, request.id, request.action, request.key);
                            if (request.parameters != null && Object.keys(request.parameters).length > 0) {
                                parts.path += MojioClient._makeParameters(request.parameters);
                            }
                            parts.headers = {};
                            if (this.getTokenId() != null) {
                                parts.headers["MojioAPIToken"] = this.getTokenId();
                            }
                            if (request.headers != null) {
                                parts.headers += request.headers;
                            }
                            parts.headers["Content-Type"] = "application/json";
                            if (request.body != null) {
                                if (isOauth) {
                                    parts.body = FormUrlencoded.encode(request.body);
                                } else {
                                    parts.body = request.body;
                                }
                            }
                            http = new Http();
                            return http.request(parts, callback);
                        }
                        authorize(redirect_url, type = "token", scope = "full", state = null, callback) {
                            var http, parts;
                            this.auth_response_type = type;
                            if (this.options != null && this.options.secret != null && this.options.username != null && this.options.password != null) {
                                return this._login(this.options.username, this.options.password, callback);
                            } else {
                                parts = {
                                    hostname: this.options.authUrl,
                                    port: this.options.port,
                                    scheme: this.options.scheme,
                                    path: this.options.live ? "/OAuth2/authorize" : "/OAuth2Sandbox/authorize",
                                    method: "Get",
                                    withCredentials: false
                                };
                                parts.path += "?response_type=" + type;
                                parts.path += "&client_id=" + this.options.application;
                                parts.path += "&redirect_uri=" + redirect_url;
                                if (scope) {
                                    parts.path += "&scope=" + scope;
                                }
                                if (state) {
                                    parts.path += "&state=" + state;
                                }
                                parts.headers = {};
                                if (this.getTokenId() != null) {
                                    parts.headers["MojioAPIToken"] = this.getTokenId();
                                }
                                parts.headers["Content-Type"] = "application/json";
                                http = new Http();
                                return http.redirect(parts, function(error, result) {
                                    this.setToken(result);
                                    if (callback == null) {
                                        return;
                                    }
                                    if (error != null) {
                                        callback(error, null);
                                    }
                                    return callback(null, result);
                                });
                            }
                        }
                        token(callback) {
                            var match, match1, match2, token1, token2;
                            this.user = null;
                            token1 = this.options.tokenRequester();
                            match1 = !!token1 && token1[1];
                            token2 = this.options.tokenRequesterImplicit();
                            match2 = !!token2 && token2[1];
                            match = match1 || match2;
                            if (!match) {
                                return callback("token for authorization not found.", null);
                            } else if (this.auth_response_type === "token" || this.auth_response_type === "password") {
                                this.setToken(match);
                                return callback(null, match);
                            } else {
                                return this.request({
                                    method: "GET",
                                    resource: this.login_resource,
                                    id: match
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        this.setToken(result);
                                        return callback(null, this.getToken());
                                    }
                                });
                            }
                        }
                        unauthorize(callback) {
                            if (this.options != null && this.options.secret != null && this.options.username != null && this.options.password != null) {
                                return this._logout(callback);
                            } else if (this.options != null && this.options.secret != null && this.options.application != null) {
                                return this._logout(callback);
                            } else {
                                this.setToken(null);
                                return callback(null, "ok");
                            }
                        }
                        _login(username, password, callback) {
                            return this.request({
                                method: "POST",
                                resource: this.options.live ? "/OAuth2/token" : "/OAuth2Sandbox/token",
                                body: {
                                    username: username,
                                    password: password,
                                    client_id: this.options.application,
                                    client_secret: this.options.secret,
                                    grant_type: "password"
                                }
                            }, (error, result) => {
                                this.setToken(result);
                                return callback(error, result);
                            }, true);
                        }
                        login(username, password, callback) {
                            return this._login(username, password, (error, result) => {
                                this.setToken(result);
                                return callback(error, result);
                            });
                        }
                        _logout(callback) {
                            return this.request({
                                method: "DELETE",
                                resource: this.login_resource,
                                id: typeof mojio_token !== "undefined" && mojio_token !== null ? mojio_token : this.getTokenId()
                            }, (error, result) => {
                                this.setToken(null);
                                return callback(error, result);
                            });
                        }
                        logout(callback) {
                            return this._logout((error, result) => {
                                this.setToken(null);
                                return callback(error, result);
                            });
                        }
                        model(type, json = null) {
                            var data, i, len, object, ref;
                            if (json === null) {
                                return mojio_models[type];
                            } else if (json.Data != null && json.Data instanceof Array) {
                                object = json;
                                object.Objects = new Array();
                                ref = json.Data;
                                for (i = 0, len = ref.length; i < len; i++) {
                                    data = ref[i];
                                    object.Objects.push(new mojio_models[type](data));
                                }
                            } else if (json.Data != null) {
                                object = new mojio_models[type](json.Data);
                            } else {
                                object = new mojio_models[type](json);
                            }
                            object._client = this;
                            return object;
                        }
                        query(model, parameters, callback) {
                            var property, query_criteria, ref, value;
                            if (parameters instanceof Object) {
                                if (parameters.criteria instanceof Object) {
                                    query_criteria = "";
                                    ref = parameters.criteria;
                                    for (property in ref) {
                                        value = ref[property];
                                        query_criteria += `${property}=${value};`;
                                    }
                                    parameters.criteria = query_criteria;
                                }
                                return this.request({
                                    method: "GET",
                                    resource: model.resource(),
                                    parameters: parameters
                                }, (error, result) => {
                                    return callback(error, this.model(model.model(), result));
                                });
                            } else if (typeof parameters === "string") {
                                return this.request({
                                    method: "GET",
                                    resource: model.resource(),
                                    parameters: {
                                        id: parameters
                                    }
                                }, (error, result) => {
                                    return callback(error, this.model(model.model(), result));
                                });
                            } else {
                                return callback("criteria given is not in understood format, string or object.", null);
                            }
                        }
                        get(model, criteria, callback) {
                            return this.query(model, criteria, callback);
                        }
                        save(model, callback) {
                            return this.request({
                                method: "PUT",
                                resource: model.resource(),
                                body: model.stringify(),
                                parameters: {
                                    id: model._id
                                }
                            }, callback);
                        }
                        put(model, callback) {
                            return this.save(model, callback);
                        }
                        create(model, callback) {
                            return this.request({
                                method: "POST",
                                resource: model.resource(),
                                body: model.stringify()
                            }, callback);
                        }
                        post(model, callback) {
                            return this.create(model, callback);
                        }
                        delete(model, callback) {
                            return this.request({
                                method: "DELETE",
                                resource: model.resource(),
                                parameters: {
                                    id: model._id
                                }
                            }, callback);
                        }
                        _schema(callback) {
                            return this.request({
                                method: "GET",
                                resource: "Schema"
                            }, callback);
                        }
                        schema(callback) {
                            return this._schema((error, result) => {
                                return callback(error, result);
                            });
                        }
                        watch(observer, observer_callback, callback) {
                            return this.request({
                                method: "POST",
                                resource: Observer.resource(),
                                body: observer.stringify()
                            }, (error, result) => {
                                if (error) {
                                    return callback(error, null);
                                } else {
                                    observer = new Observer(result);
                                    this.signalr.subscribe(this.options.signalr_hub, "Subscribe", observer.id(), observer.Subject, observer_callback, function(error, result) {
                                        return callback(null, observer);
                                    });
                                    return observer;
                                }
                            });
                        }
                        ignore(observer, observer_callback, callback) {
                            if (!observer) {
                                callback("Observer required.");
                            }
                            if (observer["subject"] != null) {
                                if (observer.parent === null) {
                                    return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), observer.subject.id(), observer_callback, callback);
                                } else {
                                    return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), observer.subject.model(), observer_callback, callback);
                                }
                            } else {
                                if (observer.parent === null) {
                                    return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), observer.SubjectId, observer_callback, callback);
                                } else {
                                    return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), observer.Subject, observer_callback, callback);
                                }
                            }
                        }
                        observe(subject, parent = null, observer_callback, callback) {
                            var observer;
                            if (parent === null) {
                                observer = new Observer({
                                    ObserverType: "Generic",
                                    Status: "Approved",
                                    Name: "Test" + Math.random(),
                                    Subject: subject.model(),
                                    SubjectId: subject.id(),
                                    Transports: "SignalR"
                                });
                                return this.request({
                                    method: "PUT",
                                    resource: Observer.resource(),
                                    body: observer.stringify()
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        observer = new Observer(result);
                                        return this.signalr.subscribe(this.options.signalr_hub, "Subscribe", observer.id(), observer.SubjectId, observer_callback, function(error, result) {
                                            return callback(null, observer);
                                        });
                                    }
                                });
                            } else {
                                observer = new Observer({
                                    ObserverType: "Generic",
                                    Status: "Approved",
                                    Name: "Test" + Math.random(),
                                    Subject: subject.model(),
                                    Parent: parent.model(),
                                    ParentId: parent.id(),
                                    Transports: "SignalR"
                                });
                                return this.request({
                                    method: "PUT",
                                    resource: Observer.resource(),
                                    body: observer.stringify()
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        observer = new Observer(result);
                                        return this.signalr.subscribe(this.options.signalr_hub, "Subscribe", observer.id(), subject.model(), observer_callback, function(error, result) {
                                            return callback(null, observer);
                                        });
                                    }
                                });
                            }
                        }
                        unobserve(observer, subject, parent, observer_callback, callback) {
                            if (!observer || subject == null) {
                                return callback("Observer and subject required.");
                            } else if (parent === null) {
                                return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), subject.id(), observer_callback, callback);
                            } else {
                                return this.signalr.unsubscribe(this.options.signalr_hub, "Unsubscribe", observer.id(), subject.model(), observer_callback, callback);
                            }
                        }
                        store(model, key, value, callback) {
                            if (!model || !model._id) {
                                return callback("Storage requires an object with a valid id.");
                            } else {
                                return this.request({
                                    method: "PUT",
                                    resource: model.resource(),
                                    id: model.id(),
                                    action: "store",
                                    key: key,
                                    body: JSON.stringify(value)
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        return callback(null, result);
                                    }
                                });
                            }
                        }
                        storage(model, key, callback) {
                            if (!model || !model._id) {
                                return callback("Get of storage requires an object with a valid id.");
                            } else {
                                return this.request({
                                    method: "GET",
                                    resource: model.resource(),
                                    id: model.id(),
                                    action: "store",
                                    key: key
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        return callback(null, result);
                                    }
                                });
                            }
                        }
                        unstore(model, key, callback) {
                            if (!model || !model._id) {
                                return callback("Storage requires an object with a valid id.");
                            } else {
                                return this.request({
                                    method: "DELETE",
                                    resource: model.resource(),
                                    id: model.id(),
                                    action: "store",
                                    key: key
                                }, (error, result) => {
                                    if (error) {
                                        return callback(error, null);
                                    } else {
                                        return callback(null, result);
                                    }
                                });
                            }
                        }
                        isAuthorized() {
                            return this.auth_token != null && this.getToken() != null;
                        }
                        setToken(token) {
                            if (token === null) {
                                return this.auth_token = {
                                    _id: null,
                                    access_token: null
                                };
                            } else if (typeof token === "object") {
                                this.auth_token = token;
                                if (!this.auth_token._id && token.access_token != null) {
                                    this.auth_token._id = token.access_token;
                                } else if (!this.auth_token.access_token && token._id != null) {
                                    this.auth_token.access_token = token._id;
                                }
                                if (this.auth_token.access_token == null && this.auth_token._id == null) {
                                    this.auth_token.access_token = null;
                                    return this.auth_token._id = null;
                                }
                            } else {
                                if (token != null) {
                                    return this.auth_token = {
                                        _id: token,
                                        access_token: token
                                    };
                                }
                            }
                        }
                        getToken() {
                            return this.auth_token.access_token;
                        }
                        getTokenId() {
                            return this.getToken();
                        }
                        getRefreshToken() {
                            return this.auth_token.refresh_token;
                        }
                        getUserId() {
                            if (this.auth_token.UserId) {
                                return this.auth_token.UserId;
                            }
                            return null;
                        }
                        isLoggedIn() {
                            return this.getUserId() !== null || this.getToken() != null;
                        }
                        getCurrentUser(callback) {
                            if (this.user != null) {
                                callback(null, this.user);
                            } else if (this.isLoggedIn()) {
                                this.get(Login, this.getToken(), (error, result) => {
                                    if (error != null) {
                                        return callback(error, null);
                                    } else if (result.UserId != null) {
                                        return this.get(User, result.UserId, (error, result) => {
                                            if (error != null) {
                                                return callback(error, null);
                                            } else {
                                                this.user = result;
                                                return callback(null, this.user);
                                            }
                                        });
                                    } else {
                                        return callback("User not found", null);
                                    }
                                });
                            } else {
                                callback("User not found", null);
                                return false;
                            }
                            return true;
                        }
                    }
                    defaults = {
                        hostname: "api.moj.io",
                        authUrl: "accounts.moj.io",
                        port: "443",
                        version: "v2",
                        scheme: "https",
                        signalr_scheme: "https",
                        signalr_port: "443",
                        signalr_hub: "ObserverHub",
                        live: true
                    };
                    MojioClient.prototype.login_resource = "Login";
                    MojioClient.prototype.auth_response_type = "token";
                    mojio_models = {};
                    App = require("../models/App");
                    mojio_models["App"] = App;
                    Login = require("../models/Login");
                    mojio_models["Login"] = Login;
                    Mojio = require("../models/Mojio");
                    mojio_models["Mojio"] = Mojio;
                    Trip = require("../models/Trip");
                    mojio_models["Trip"] = Trip;
                    User = require("../models/User");
                    mojio_models["User"] = User;
                    Vehicle = require("../models/Vehicle");
                    mojio_models["Vehicle"] = Vehicle;
                    Product = require("../models/Product");
                    mojio_models["Product"] = Product;
                    Subscription = require("../models/Subscription");
                    mojio_models["Subscription"] = Subscription;
                    Event = require("../models/Event");
                    mojio_models["Event"] = Event;
                    Observer = require("../models/Observer");
                    mojio_models["Observer"] = Observer;
                    return MojioClient;
                }();
            }).call(this);
        }, {
            "../models/App": 5,
            "../models/Event": 6,
            "../models/Login": 7,
            "../models/Mojio": 8,
            "../models/Observer": 10,
            "../models/Product": 11,
            "../models/Subscription": 12,
            "../models/Trip": 13,
            "../models/User": 14,
            "../models/Vehicle": 15,
            "./HttpBrowserWrapper": 3,
            "./SignalRBrowserWrapper": 4,
            "form-urlencoded": 2
        } ],
        1: [ function(require, module, exports) {
            var formurlencoded = (typeof module === "object" ? module : {}).exports = {
                encode: function(data, options) {
                    function getNestValsArrAsStr(arr) {
                        return arr.filter(function(e) {
                            return typeof e === "string" && e.length;
                        }).join("&");
                    }
                    function getKeys(obj) {
                        var keys = Object.keys(obj);
                        return options && options.sorted ? keys.sort() : keys;
                    }
                    function getObjNestVals(name, obj) {
                        var objKeyStr = ":name[:prop]";
                        return getNestValsArrAsStr(getKeys(obj).map(function(key) {
                            return getNestVals(objKeyStr.replace(/:name/, name).replace(/:prop/, key), obj[key]);
                        }));
                    }
                    function getArrNestVals(name, arr) {
                        var arrKeyStr = ":name[]";
                        return getNestValsArrAsStr(arr.map(function(elem) {
                            return getNestVals(arrKeyStr.replace(/:name/, name), elem);
                        }));
                    }
                    function getNestVals(name, value) {
                        var whitespaceRe = /%20/g, type = typeof value, f = null;
                        if (type === "string") {
                            f = encodeURIComponent(name) + "=" + formEncodeString(value);
                        } else if (type === "number") {
                            f = encodeURIComponent(name) + "=" + encodeURIComponent(value).replace(whitespaceRe, "+");
                        } else if (type === "boolean") {
                            f = encodeURIComponent(name) + "=" + value;
                        } else if (Array.isArray(value)) {
                            f = getArrNestVals(name, value);
                        } else if (type === "object") {
                            f = getObjNestVals(name, value);
                        }
                        return f;
                    }
                    function manuallyEncodeChar(ch) {
                        return "%" + ("0" + ch.charCodeAt(0).toString(16)).slice(-2).toUpperCase();
                    }
                    function formEncodeString(value) {
                        return value.replace(/[^ !'()~\*]*/g, encodeURIComponent).replace(/ /g, "+").replace(/[!'()~\*]/g, manuallyEncodeChar);
                    }
                    return getNestValsArrAsStr(getKeys(data).map(function(key) {
                        return getNestVals(key, data[key]);
                    }));
                }
            };
        }, {} ],
        2: [ function(require, module, exports) {
            module.exports = require("./form-urlencoded");
        }, {
            "./form-urlencoded": 1
        } ],
        3: [ function(require, module, exports) {
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
                        if (params.host == null && params.hostname != null) {
                            params.host = params.hostname;
                        }
                        if (!(params.scheme != null || (typeof window === "undefined" || window === null))) {
                            params.scheme = window.location.protocol.split(":")[0];
                        }
                        if (!params.scheme || params.scheme === "file") {
                            params.scheme = "https";
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
                        if (params.method === "GET" && params.data != null && params.data.length > 0) {
                            url += "?" + Object.keys(params.data).map(function(k) {
                                return encodeURIComponent(k) + "=" + encodeURIComponent(params.data[k]);
                            }).join("&");
                        }
                        if (typeof XMLHttpRequest !== "undefined" && XMLHttpRequest !== null) {
                            xmlhttp = new XMLHttpRequest();
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
                    redirect(params, callback) {
                        var url;
                        url = params.scheme + "://" + params.hostname + ":" + params.port + params.path;
                        return window.location = url;
                    }
                };
            }).call(this);
        }, {} ],
        4: [ function(require, module, exports) {
            (function() {
                var SignalRBrowserWrapper;
                module.exports = SignalRBrowserWrapper = function() {
                    class SignalRBrowserWrapper {
                        observer_registry(entity) {
                            var callback, i, j, len, len1, ref, ref1, results, results1;
                            if (this.observer_callbacks[entity._id]) {
                                ref = this.observer_callbacks[entity._id];
                                results = [];
                                for (i = 0, len = ref.length; i < len; i++) {
                                    callback = ref[i];
                                    results.push(callback(entity));
                                }
                                return results;
                            } else if (this.observer_callbacks[entity.Type]) {
                                ref1 = this.observer_callbacks[entity.Type];
                                results1 = [];
                                for (j = 0, len1 = ref1.length; j < len1; j++) {
                                    callback = ref1[j];
                                    results1.push(callback(entity));
                                }
                                return results1;
                            }
                        }
                        constructor(url, hubNames, jquery) {
                            this.observer_registry = this.observer_registry.bind(this);
                            this.$ = jquery;
                            this.url = url;
                            this.hubs = {};
                            this.signalr = null;
                            this.connectionStatus = false;
                        }
                        getHub(which, callback) {
                            if (this.hubs[which]) {
                                return callback(null, this.hubs[which]);
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
                                this.hubs[which] = this.signalr.createHubProxy(which);
                                this.hubs[which].on("error", function(data) {
                                    return console.log("Hub '" + which + "' has error" + data);
                                });
                                this.hubs[which].on("UpdateEntity", this.observer_registry);
                                if (this.hubs[which].connection.state !== 1) {
                                    if (!this.connectionStatus) {
                                        return this.signalr.start().done(() => {
                                            this.connectionStatus = true;
                                            return this.hubs[which].connection.start().done(() => {
                                                return callback(null, this.hubs[which]);
                                            });
                                        });
                                    } else {
                                        return this.hubs[which].connection.start().done(() => {
                                            return callback(null, this.hubs[which]);
                                        });
                                    }
                                } else {
                                    return callback(null, this.hubs[which]);
                                }
                            }
                        }
                        setCallback(id, futureCallback) {
                            if (this.observer_callbacks[id] == null) {
                                this.observer_callbacks[id] = [];
                            }
                            this.observer_callbacks[id].push(futureCallback);
                        }
                        removeCallback(id, pastCallback) {
                            var callback, i, len, ref, temp;
                            if (pastCallback === null) {
                                this.observer_callbacks[id] = [];
                            } else {
                                temp = [];
                                ref = this.observer_callbacks[id];
                                for (i = 0, len = ref.length; i < len; i++) {
                                    callback = ref[i];
                                    if (callback !== pastCallback) {
                                        temp.push(callback);
                                    }
                                }
                                this.observer_callbacks[id] = temp;
                            }
                        }
                        subscribe(hubName, method, observerId, subject, futureCallback, callback) {
                            this.setCallback(subject, futureCallback);
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
                        }
                        unsubscribe(hubName, method, observerId, subject, pastCallback, callback) {
                            this.removeCallback(subject, pastCallback);
                            if (this.observer_callbacks[subject].length === 0) {
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
                        }
                    }
                    SignalRBrowserWrapper.prototype.observer_callbacks = {};
                    return SignalRBrowserWrapper;
                }();
            }).call(this);
        }, {} ],
        5: [ function(require, module, exports) {
            (function() {
                var App, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = App = function() {
                    class App extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return App._resource;
                        }
                        static model() {
                            return App._model;
                        }
                    }
                    App.prototype._schema = {
                        Type: "String",
                        Name: "String",
                        Description: "String",
                        CreationDate: "String",
                        Downloads: "Integer",
                        RedirectUris: "String",
                        ApplicationType: "String",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    App.prototype._resource = "Apps";
                    App.prototype._model = "App";
                    App._resource = "Apps";
                    App._model = "App";
                    return App;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        6: [ function(require, module, exports) {
            (function() {
                var Event, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = Event = function() {
                    class Event extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Event._resource;
                        }
                        static model() {
                            return Event._model;
                        }
                    }
                    Event.prototype._schema = {
                        Type: "Integer",
                        MojioId: "String",
                        VehicleId: "String",
                        OwnerId: "String",
                        EventType: "Integer",
                        Time: "String",
                        Location: {
                            Lat: "Float",
                            Lng: "Float",
                            FromLockedGPS: "Boolean",
                            Dilution: "Float"
                        },
                        TimeIsApprox: "Boolean",
                        BatteryVoltage: "Float",
                        ConnectionLost: "Boolean",
                        _id: "String",
                        _deleted: "Boolean",
                        Accelerometer: {
                            X: "Float",
                            Y: "Float",
                            Z: "Float"
                        },
                        TripId: "String",
                        Altitude: "Float",
                        Heading: "Float",
                        Distance: "Float",
                        FuelLevel: "Float",
                        FuelEfficiency: "Float",
                        Speed: "Float",
                        Acceleration: "Float",
                        Deceleration: "Float",
                        Odometer: "Float",
                        RPM: "Integer",
                        DTCs: "Array",
                        MilStatus: "Boolean",
                        Force: "Float",
                        MaxSpeed: "Float",
                        AverageSpeed: "Float",
                        MovingTime: "Float",
                        IdleTime: "Float",
                        StopTime: "Float",
                        MaxRPM: "Float",
                        EventTypes: "Array",
                        Timing: "Integer",
                        Name: "String",
                        ObserverType: "Integer",
                        AppId: "String",
                        Parent: "String",
                        ParentId: "String",
                        Subject: "String",
                        SubjectId: "String",
                        Transports: "Integer",
                        Status: "Integer",
                        Tokens: "Array",
                        TimeWindow: "String",
                        BroadcastOnlyRecent: "Boolean",
                        Throttle: "String",
                        NextAllowedBroadcast: "String"
                    };
                    Event.prototype._resource = "Events";
                    Event.prototype._model = "Event";
                    Event._resource = "Events";
                    Event._model = "Event";
                    return Event;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        7: [ function(require, module, exports) {
            (function() {
                var Login, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = Login = function() {
                    class Login extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Login._resource;
                        }
                        static model() {
                            return Login._model;
                        }
                    }
                    Login.prototype._schema = {
                        Type: "String",
                        AppId: "String",
                        UserId: "String",
                        ValidUntil: "String",
                        Scopes: "String",
                        Sandboxed: "Boolean",
                        Depricated: "Boolean",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    Login.prototype._resource = "Login";
                    Login.prototype._model = "Login";
                    Login._resource = "Login";
                    Login._model = "Login";
                    return Login;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        8: [ function(require, module, exports) {
            (function() {
                var Mojio, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = Mojio = function() {
                    class Mojio extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Mojio._resource;
                        }
                        static model() {
                            return Mojio._model;
                        }
                    }
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
                    return Mojio;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        9: [ function(require, module, exports) {
            (function() {
                var MojioModel;
                module.exports = MojioModel = function() {
                    class MojioModel {
                        constructor(json) {
                            this._client = null;
                            this.validate(json);
                        }
                        setField(field, value) {
                            this[field] = value;
                            return this[field];
                        }
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
                                    method: "GET",
                                    resource: this.resource(),
                                    parameters: criteria
                                }, (error, result) => {
                                    return callback(error, this._client.model(this.model(), result));
                                });
                            } else if (typeof criteria === "string") {
                                return this._client.request({
                                    method: "GET",
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
                        create(callback) {
                            if (this._client === null) {
                                callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
                                return;
                            }
                            return this._client.request({
                                method: "POST",
                                resource: this.resource(),
                                body: this.stringify()
                            }, callback);
                        }
                        post(callback) {
                            return this.create(callback);
                        }
                        save(callback) {
                            if (this._client === null) {
                                callback("No authorization set for model, use authorize(), passing in a mojio _client where login() has been called successfully.", null);
                                return;
                            }
                            return this._client.request({
                                method: "PUT",
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
                        delete(callback) {
                            return this._client.request({
                                method: "DELETE",
                                resource: this.resource(),
                                parameters: {
                                    id: this._id
                                }
                            }, callback);
                        }
                        observe(parent = null, observer_callback, callback, options) {
                            if (parent != null) {
                                return this._client.observe(this.resource, parent, observer_callback, callback, options = {});
                            } else {
                                return this._client.observe(this, null, observer_callback, callback, options);
                            }
                        }
                        unobserve(parent = null, observer_callback, callback) {
                            if (parent != null) {
                                return this._client.unobserve(this.resource, parent, observer_callback, callback);
                            } else {
                                return this._client.unobserve(this, null, observer_callback, callback);
                            }
                        }
                        store(model, key, value, callback) {
                            return this._client.store(model, key, value, callback);
                        }
                        storage(model, key, callback) {
                            return this._client.storage(model, key, callback);
                        }
                        unstore(model, key, callback) {
                            return this._client.unstore(model, key, callback);
                        }
                        statistic(expression, callback) {
                            return callback(null, true);
                        }
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
                                } else if (field !== "_id" || withid) {
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
                    }
                    MojioModel._resource = "Schema";
                    MojioModel._model = "Model";
                    return MojioModel;
                }();
            }).call(this);
        }, {} ],
        10: [ function(require, module, exports) {
            (function() {
                var MojioModel, Observer;
                MojioModel = require("./MojioModel");
                module.exports = Observer = function() {
                    class Observer extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Observer._resource;
                        }
                        static model() {
                            return Observer._model;
                        }
                    }
                    Observer.prototype._schema = {
                        Type: "String",
                        Name: "String",
                        ObserverType: "String",
                        EventTypes: "Array",
                        AppId: "String",
                        OwnerId: "String",
                        Parent: "String",
                        ParentId: "String",
                        Subject: "String",
                        SubjectId: "String",
                        Transports: "Integer",
                        Status: "Integer",
                        Tokens: "Array",
                        TimeWindow: "String",
                        BroadcastOnlyRecent: "Boolean",
                        Throttle: "String",
                        NextAllowedBroadcast: "String",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    Observer.prototype._resource = "Observers";
                    Observer.prototype._model = "Observer";
                    Observer._resource = "Observers";
                    Observer._model = "Observer";
                    return Observer;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        11: [ function(require, module, exports) {
            (function() {
                var MojioModel, Product;
                MojioModel = require("./MojioModel");
                module.exports = Product = function() {
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
                    }
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
                    return Product;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        12: [ function(require, module, exports) {
            (function() {
                var MojioModel, Subscription;
                MojioModel = require("./MojioModel");
                module.exports = Subscription = function() {
                    class Subscription extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Subscription._resource;
                        }
                        static model() {
                            return Subscription._model;
                        }
                    }
                    Subscription.prototype._schema = {
                        Type: "Integer",
                        ChannelType: "Integer",
                        ChannelTarget: "String",
                        AppId: "String",
                        OwnerId: "String",
                        Event: "Integer",
                        EntityType: "Integer",
                        EntityId: "String",
                        Interval: "Integer",
                        LastMessage: "String",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    Subscription.prototype._resource = "Subscriptions";
                    Subscription.prototype._model = "Subscription";
                    Subscription._resource = "Subscriptions";
                    Subscription._model = "Subscription";
                    return Subscription;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        13: [ function(require, module, exports) {
            (function() {
                var MojioModel, Trip;
                MojioModel = require("./MojioModel");
                module.exports = Trip = function() {
                    class Trip extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Trip._resource;
                        }
                        static model() {
                            return Trip._model;
                        }
                    }
                    Trip.prototype._schema = {
                        Type: "Integer",
                        MojioId: "String",
                        VehicleId: "String",
                        StartTime: "String",
                        LastUpdatedTime: "String",
                        EndTime: "String",
                        MaxSpeed: "Float",
                        MaxAcceleration: "Float",
                        MaxDeceleration: "Float",
                        MaxRPM: "Integer",
                        FuelLevel: "Float",
                        FuelEfficiency: "Float",
                        Distance: "Float",
                        MovingTime: "Float",
                        IdleTime: "Float",
                        StopTime: "Float",
                        StartLocation: {
                            Lat: "Float",
                            Lng: "Float",
                            FromLockedGPS: "Boolean",
                            Dilution: "Float"
                        },
                        LastKnownLocation: {
                            Lat: "Float",
                            Lng: "Float",
                            FromLockedGPS: "Boolean",
                            Dilution: "Float"
                        },
                        EndLocation: {
                            Lat: "Float",
                            Lng: "Float",
                            FromLockedGPS: "Boolean",
                            Dilution: "Float"
                        },
                        StartAddress: {
                            Address1: "String",
                            Address2: "String",
                            City: "String",
                            State: "String",
                            Zip: "String",
                            Country: "String"
                        },
                        EndAddress: {
                            Address1: "String",
                            Address2: "String",
                            City: "String",
                            State: "String",
                            Zip: "String",
                            Country: "String"
                        },
                        ForcefullyEnded: "Boolean",
                        StartMilage: "Float",
                        EndMilage: "Float",
                        StartOdometer: "Float",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    Trip.prototype._resource = "Trips";
                    Trip.prototype._model = "Trip";
                    Trip._resource = "Trips";
                    Trip._model = "Trip";
                    return Trip;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        14: [ function(require, module, exports) {
            (function() {
                var MojioModel, User;
                MojioModel = require("./MojioModel");
                module.exports = User = function() {
                    class User extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return User._resource;
                        }
                        static model() {
                            return User._model;
                        }
                    }
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
                    return User;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ],
        15: [ function(require, module, exports) {
            (function() {
                var MojioModel, Vehicle;
                MojioModel = require("./MojioModel");
                module.exports = Vehicle = function() {
                    class Vehicle extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Vehicle._resource;
                        }
                        static model() {
                            return Vehicle._model;
                        }
                    }
                    Vehicle.prototype._schema = {
                        Type: "Integer",
                        OwnerId: "String",
                        MojioId: "String",
                        Name: "String",
                        VIN: "String",
                        LicensePlate: "String",
                        IgnitionOn: "Boolean",
                        VehicleTime: "String",
                        LastTripEvent: "String",
                        LastLocationTime: "String",
                        LastLocation: {
                            Lat: "Float",
                            Lng: "Float",
                            FromLockedGPS: "Boolean",
                            Dilution: "Float"
                        },
                        LastSpeed: "Float",
                        FuelLevel: "Float",
                        LastAcceleration: "Float",
                        LastAccelerometer: "Object",
                        LastAltitude: "Float",
                        LastBatteryVoltage: "Float",
                        LastDistance: "Float",
                        LastHeading: "Float",
                        LastVirtualOdometer: "Float",
                        LastOdometer: "Float",
                        LastRpm: "Float",
                        LastFuelEfficiency: "Float",
                        CurrentTrip: "String",
                        LastTrip: "String",
                        LastContactTime: "String",
                        MilStatus: "Boolean",
                        DiagnosticCodes: "Object",
                        FaultsDetected: "Boolean",
                        LastLocationTimes: "Array",
                        LastLocations: "Array",
                        LastSpeeds: "Array",
                        LastHeadings: "Array",
                        LastAltitudes: "Array",
                        Viewers: "Array",
                        _id: "String",
                        _deleted: "Boolean"
                    };
                    Vehicle.prototype._resource = "Vehicles";
                    Vehicle.prototype._model = "Vehicle";
                    Vehicle._resource = "Vehicles";
                    Vehicle._model = "Vehicle";
                    return Vehicle;
                }();
            }).call(this);
        }, {
            "./MojioModel": 9
        } ]
    }, {}, [])("/MojioClient.js");
});