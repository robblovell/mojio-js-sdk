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
        g.Address = f();
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
        "/Address.js": [ function(require, module, exports) {
            (function() {
                var Address, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = Address = function() {
                    class Address extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Address._resource;
                        }
                        static model() {
                            return Address._model;
                        }
                    }
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
                    return Address;
                }();
            }).call(this);
        }, {
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Address.js");
});

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
        g.App = f();
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
        "/App.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/App.js");
});

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
        g.Event = f();
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
        "/Event.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Event.js");
});

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
        g.Location = f();
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
        "/Location.js": [ function(require, module, exports) {
            (function() {
                var Location, MojioModel;
                MojioModel = require("./MojioModel");
                module.exports = Location = function() {
                    class Location extends MojioModel {
                        constructor(json) {
                            super(json);
                        }
                        static resource() {
                            return Location._resource;
                        }
                        static model() {
                            return Location._model;
                        }
                    }
                    Location.prototype._schema = {
                        Lat: "Float",
                        Lng: "Float",
                        FromLockedGPS: "Boolean",
                        Dilution: "Float",
                        IsValid: "Boolean"
                    };
                    Location.prototype._resource = "Locations";
                    Location.prototype._model = "Location";
                    Location._resource = "Locations";
                    Location._model = "Location";
                    return Location;
                }();
            }).call(this);
        }, {
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Location.js");
});

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
        g.Mojio = f();
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
        "/Mojio.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Mojio.js");
});

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
        g.Observer = f();
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
        "/Observer.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Observer.js");
});

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
        g.Product = f();
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
        "/Product.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Product.js");
});

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
        g.Subscription = f();
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
        "/Subscription.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Subscription.js");
});

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
        g.Trip = f();
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
        "/Trip.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/Trip.js");
});

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
        g.User = f();
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
        "/User.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ],
        1: [ function(require, module, exports) {
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
        }, {} ]
    }, {}, [])("/User.js");
});

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
        g.Vehicle = f();
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
        1: [ function(require, module, exports) {
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
        "/Vehicle.js": [ function(require, module, exports) {
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
            "./MojioModel": 1
        } ]
    }, {}, [])("/Vehicle.js");
});