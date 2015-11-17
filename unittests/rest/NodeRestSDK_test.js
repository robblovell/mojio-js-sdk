// Generated by CoffeeScript 1.10.0
(function() {
  var MojioRestSDK, MojioSDK, async, nock, should;

  MojioSDK = require('../../src/nodejs/sdk/MojioSDK');

  MojioRestSDK = require('../../src/nodejs/sdk/MojioRestSDK');

  should = require('should');

  async = require('async');

  nock = require('nock');

  describe('Node Mojio Fluent Rest SDK', function() {
    var authorization, call, callback_url, client_id, client_secret, execute, mojio, sdk, setupAuthorizeNock, setupNock, setupPostPutNock, setupTokenNock, testErrorResult, timeout, user, vehicle;
    user = null;
    mojio = null;
    vehicle = null;
    client_id = '41a04077-0157-49fb-a35c-6e2824f3b348';
    client_secret = 'd80357f8-cbc9-4022-b340-6e99a72e7e0b';
    call = null;
    timeout = 50;
    callback_url = "http://localhost:3000/callback";
    authorization = {
      client_id: client_id,
      client_secret: client_secret,
      redirect_uri: 'http://localhost:3000/callback',
      username: 'testing@moj.io',
      password: 'Test123!',
      scope: 'full',
      grant_type: 'password'
    };
    sdk = new MojioSDK({
      sdk: MojioRestSDK,
      client_id: client_id,
      client_secret: client_secret,
      test: true
    });
    setupTokenNock = function() {
      if ((process.env.FUNCTIONAL_TESTS != null)) {
        timeout = 3000;
        return {
          done: function() {}
        };
      } else {
        call = nock('https://accounts.moj.io').post("/oauth2/token", {
          client_id: client_id,
          client_secret: client_secret
        }).reply(function(uri, requestBody, cb) {
          return cb(null, [
            200, {
              id: 1,
              access_token: "token"
            }
          ]);
        });
        return call;
      }
    };
    setupAuthorizeNock = function() {
      if ((process.env.FUNCTIONAL_TESTS != null)) {
        timeout = 3000;
        return {
          done: function() {}
        };
      } else {
        call = nock('https://accounts.moj.io').post("/oauth2/token", authorization).reply(function(uri, requestBody, cb) {
          return cb(null, [
            200, {
              id: 1,
              access_token: "token"
            }
          ]);
        });
        return call;
      }
    };
    setupNock = function(api, verb, version, primary_, pid_, secondary_, sid_, _tertiary, tid_) {
      var pid, primary, secondary, sid, tertiary, tid;
      if ((process.env.FUNCTIONAL_TESTS != null)) {
        timeout = 3000;
        return {
          done: function() {}
        };
      } else {
        pid = pid_;
        sid = sid_;
        tid = tid_;
        secondary = secondary_;
        primary = primary_;
        tertiary = _tertiary;
        call = nock(api).filteringPath(function(path) {
          var idRegex, parts, valid, versionValid;
          parts = path.split('/');
          idRegex = /\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b/;
          parts = parts.slice(1, parts.length);
          versionValid = parts[0] === version;
          parts = parts.slice(1, parts.length);
          if (parts.length === 1) {
            valid = parts[0] === primary;
          } else if (parts.length === 2) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid);
          } else if (parts.length === 3) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid) && parts[2] === secondary;
          } else if (parts.length === 4 && (sid != null)) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid) && parts[2] === secondary && (parts[3].match(idRegex) || parts[3] === "" + sid);
          } else if (parts.length === 4 && (sid == null)) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid) && parts[2] === secondary && parts[3] === tertiary;
          } else if (parts.length === 5) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid) && parts[2] === secondary && (parts[3].match(idRegex) || parts[3] === "" + sid) && parts[4] === tertiary;
          } else if (parts.length === 6) {
            valid = parts[0] === primary && (parts[1].match(idRegex) || parts[1] === "" + pid) && parts[2] === secondary && (parts[3].match(idRegex) || parts[3] === "" + sid) && parts[4] === tertiary && (parts[5].match(idRegex) || parts[5] === "" + tid);
          }
          if (valid && versionValid) {
            return '/true';
          } else {
            return '/false';
          }
        })[verb]('/true').reply(function(uri, requestBody, cb) {
          return cb(null, [
            200, {
              id: 1,
              message: "hi"
            }
          ]);
        });
        return call;
      }
    };
    setupPostPutNock = function(api, verb, version, primary_, pid_, secondary_, data_) {
      var check;
      if ((process.env.FUNCTIONAL_TESTS != null)) {
        timeout = 3000;
        return {
          done: function() {}
        };
      } else {
        check = {
          pid: pid_,
          data: data_,
          secondary: secondary_,
          primary: primary_
        };
        call = nock(api).filteringPath(function(path) {
          var idRegex, parts, valid, versionValid;
          parts = path.split('/');
          idRegex = /\b[A-F0-9]{8}(?:-[A-F0-9]{4}){3}-[A-F0-9]{12}\b/;
          parts = parts.slice(1, parts.length);
          versionValid = parts[0] === version;
          parts = parts.slice(1, parts.length);
          if (parts.length === 1) {
            valid = parts[0] === check.primary;
          } else if (parts.length === 3) {
            valid = parts[0] === check.primary && (parts[1].match(idRegex) || parts[1] === "" + check.pid) && parts[2] === check.secondary;
          }
          if (valid && versionValid) {
            return '/true';
          } else {
            return '/false';
          }
        })[verb]('/true', check.data).reply(function(uri, requestBody, cb) {
          return cb(null, [
            200, {
              id: 1,
              name: "name"
            }
          ]);
        });
        return null;
      }
    };
    testErrorResult = function(error, result) {
      if (error != null) {
        console.log("ERROR: " + error);
      }
      (error === null).should.be["true"];
      return (result !== null).should.be["true"];
    };
    execute = function(test, done) {
      return async.series([
        function(cb) {
          setupAuthorizeNock();
          return sdk.token(authorization.redirect_uri).credentials(authorization.username, authorization.password).scope(['full']).callback(function(error, result) {
            if (error) {
              console.log('Access Token Error', JSON.stringify(error.content) + "  message:" + error.statusMessage + "  url:" + sdk.url());
              return cb(error, result);
            } else {
              setupTokenNock();
              return sdk.token().parse(result).callback(function(error, result) {
                var token;
                token = result;
                return cb(error, result);
              });
            }
          });
        }, function(cb) {
          return test(cb);
        }
      ], function(error, results) {
        if (error != null) {
          console.log(error);
        }
        (error === null).should.be["true"];
        (results !== null).should.be["true"];
        return done();
      });
    };
    beforeEach(function() {
      user = null;
      mojio = null;
      return vehicle = null;
    });
    it('can GET a resource or list of resources, secondary resource, or history by ids or no query', function(done) {
      var docall, entities, entity, i, j, k, l, len, len1, len2, len3, results1, secondaries, secondaryEntity, tertiary, tertiaryEntity;
      docall = function(entity, pid, secondary, sid, tertiary, tid) {
        var finish;
        if (pid == null) {
          pid = null;
        }
        if (secondary == null) {
          secondary = null;
        }
        if (sid == null) {
          sid = null;
        }
        if (tertiary == null) {
          tertiary = null;
        }
        if (tid == null) {
          tid = null;
        }
        if (entity === 'Trips' && secondary === 'History' && tertiary === 'Locations') {
          finish = done;
        } else {
          finish = (function() {});
        }
        return execute(function(cb) {
          if ((tertiary != null)) {
            setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, null, tertiary, null);
            return sdk.get()[entity](pid)[secondary]()[tertiary]().callback(function(error, result) {
              testErrorResult(error, result);
              return cb(null, result);
            });
          } else if ((secondary != null)) {
            if (sid != null) {
              setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, sid, null, null);
              return sdk.get()[entity](pid)[secondary](sid).callback(function(error, result) {
                testErrorResult(error, result);
                return cb(null, result);
              });
            } else if (pid != null) {
              setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, secondary, null, null, null);
              return sdk.get()[entity](pid)[secondary]().callback(function(error, result) {
                testErrorResult(error, result);
                return cb(null, result);
              });
            }
          } else {
            if (pid != null) {
              setupNock('https://api2.moj.io', 'get', 'v2', entity, pid, null, null, null, null);
              return sdk.get()[entity](pid).callback(function(error, result) {
                testErrorResult(error, result);
                return cb(null, result);
              });
            } else {
              if (entity === 'me') {
                setupNock('https://api2.moj.io', 'get', 'v2', entity, null, null, null, null, null);
                sdk.me().callback(function(error, result) {
                  testErrorResult(error, result);
                  return cb(null, result);
                });
              } else {
                setupNock('https://api2.moj.io', 'get', 'v2', entity, null, null, null, null, null);
                return sdk.get()[entity]().callback(function(error, result) {
                  testErrorResult(error, result);
                  return cb(null, result);
                });
              }
            }
          }
        }, finish);
      };
      entities = ['me'];
      for (i = 0, len = entities.length; i < len; i++) {
        entity = entities[i];
        docall(entity);
      }
      entities = ['Vehicles', 'Mojios', 'Users', 'Apps', 'Groups', 'Trips'];
      secondaries = ['Tags', 'Permissions'];
      for (j = 0, len1 = entities.length; j < len1; j++) {
        entity = entities[j];
        docall(entity);
        docall(entity, 1);
        for (k = 0, len2 = secondaries.length; k < len2; k++) {
          secondaryEntity = secondaries[k];
          docall(entity, 1, secondaryEntity);
          docall(entity, 1, secondaryEntity, 1);
        }
      }
      entities = ['Vehicles', 'Trips'];
      secondaries = ['History'];
      tertiary = ['States', 'Locations'];
      results1 = [];
      for (l = 0, len3 = entities.length; l < len3; l++) {
        entity = entities[l];
        results1.push((function() {
          var len4, m, results2;
          results2 = [];
          for (m = 0, len4 = secondaries.length; m < len4; m++) {
            secondaryEntity = secondaries[m];
            results2.push((function() {
              var len5, n, results3;
              results3 = [];
              for (n = 0, len5 = tertiary.length; n < len5; n++) {
                tertiaryEntity = tertiary[n];
                results3.push(docall(entity, 1, secondaryEntity, null, tertiaryEntity, null));
              }
              return results3;
            })());
          }
          return results2;
        })());
      }
      return results1;
    });
    return it('can POST and PUT entities and get a resource or secondary resource by ids or lists', function(done) {
      var docall, entities, entity, i, len, results1, secondaries, secondaryEntity;
      docall = function(verb, entity, pid, secondary, data) {
        var finish;
        if (pid == null) {
          pid = null;
        }
        if (secondary == null) {
          secondary = null;
        }
        if (data == null) {
          data = null;
        }
        if (entity === 'Trips' && secondary === 'Permissions' && verb === 'put') {
          finish = done;
        } else {
          finish = (function() {});
        }
        return execute(function(cb) {
          if ((secondary != null)) {
            call = setupPostPutNock('https://api2.moj.io', verb, 'v2', entity, pid, secondary, data);
            return sdk[verb]()[entity](pid)[secondary](data).callback(function(error, result) {
              testErrorResult(error, result);
              return cb(null, result);
            });
          } else {
            call = setupPostPutNock('https://api2.moj.io', verb, 'v2', entity, null, null, data);
            return sdk[verb]()[entity](data).callback(function(error, result) {
              testErrorResult(error, result);
              return cb(null, result);
            });
          }
        }, finish);
      };
      entities = ['Mojios', 'Vehicles', 'Users', 'Apps', 'Groups', 'Trips'];
      secondaries = ['Tags', 'Permissions', 'Images', 'Details'];
      results1 = [];
      for (i = 0, len = entities.length; i < len; i++) {
        entity = entities[i];
        docall('post', entity, null, null, {
          name: 'name' + entity
        });
        docall('put', entity, null, null, {
          name: 'name' + entity
        });
        results1.push((function() {
          var j, len1, results2;
          results2 = [];
          for (j = 0, len1 = secondaries.length; j < len1; j++) {
            secondaryEntity = secondaries[j];
            docall('post', entity, 1, secondaryEntity, {
              name: 'name/' + entity + '/1/' + secondaryEntity
            });
            results2.push(docall('put', entity, 1, secondaryEntity, {
              name: 'name/' + entity + '/1/' + secondaryEntity
            }));
          }
          return results2;
        })());
      }
      return results1;
    });
  });

}).call(this);

//# sourceMappingURL=NodeRestSDK_test.js.map
