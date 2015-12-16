MojioSDK = require '../../src/nodejs/sdk/MojioSDK'
MojioRestSDK = require '../../src/nodejs/sdk/MojioRestSDK'

should = require('should')
async = require('async')
nock = require 'nock'


nock('https://staging-accounts.moj.io')
.post("/oauth2/token", authorization)
.reply((uri, requestBody, cb) ->
    cb(null, [200, { id: 1}]))

describe 'Node Mojio Fluent Rest SDK GET calls', ->

    redirect_url = 'http://localhost'
    client_id = 'cacc0d94-b6b4-4da7-9983-3991de197038'

    sdk = new MojioSDK({ client_id: client_id, sdk: MojioPushSDK})

    it 'can authorize', (done) ->
        redirect_technology = { redirect: ((url) -> done(); return) }
        sdk
        .authorize(redirect_uri)
        .scope(['full'])
        .redirect(redirect_technology)

    it 'can get token from redirect', (done) ->
        sdk
        .token(redirect_uri)
        .parse(req)
        .callback((error, result) ->
            token = result
            done()
        )

    # users
    it 'can get the current logged in user', (done) ->
        tests = [
            (cb) -> sdk.me().callback(cb)
            (cb) -> sdk.get().me().callback(cb)
            (cb) -> sdk.user().callback(cb)
            (cb) -> sdk.get().user().callback(cb)
        ]
        answers = [
            "/me"
            "/me"
            "/users"
            "/users"
        ]

    it 'can get a user the current user has access to', (done) ->
        tests = [
            (cb) -> sdk.user({id: "otherId"}).callback(cb)
            (cb) -> sdk.get().user({id: "otherId"}).callback(cb)
        ]
        answers = [
            ["GET", "/users/otherId"]
            ["GET", "/users/otherId"]
        ]
    it "can update a user's details", (done) ->
        tests = [
            (cb) -> sdk.update().user({id: "id"}).details({ email: "a@b" }).callback(cb)
            (cb) -> sdk.update().user("id").details({ email: "s@b" }).callback(cb)
        ]
        answers = [
            "/users/otherId"
            "/users/otherId"
        ]
    # apps
    it "can get the user's apps", (done) ->
        tests = [
            (cb) -> sdk.get().apps().callback(cb)
            (cb) -> sdk.get().user({id: "id"}).apps().callback(cb)
            (cb) -> sdk.user().apps().callback(cb)
            (cb) -> sdk.user({id: "id"}).apps().callback(cb)
            (cb) -> sdk.get().apps().callback(cb)
            (cb) -> sdk.get().user({id: "id"}).apps({id: "id"}).callback(cb)
            (cb) -> sdk.user().apps().callback(cb)
            (cb) -> sdk.user({id: "id"}).apps({id: "id"}).callback(cb)
        ]
        answers = [
            "/apps"
            "/users/id/apps"
            "/users/id/apps"
        ]
    it "can get a specific app of the user", (done) ->

    it "can get a specific app of the user by id", (done) ->

    it "can get a specific app's secret key", (done) ->

    it "can update a specific apps's details (found by license)", (done) ->

    # vehicles
    it "can get the user's vehicles", (done) ->

    it "can get a specific vehicle of the user", (done) ->

    it "can get a specific vehicle of the user by id", (done) ->

    it "can update a specific vehicle's details (found by license)", (done) ->

    it "can get a vehicle's location history in a date range", (done) ->

    it "can get a vehicle's state history in a date range", (done) ->

    # trips
    it "can get all the user's trips", (done) ->

    it "can get 10 of the user's trips on page 2 of 10", (done) ->

    it "can get 10 of the user's trips within a date range", (done) ->

    it "can update a specific trip's details (found by date and limit 1)", (done) ->

    it "can get a trip's vehicle location history in a date range", (done) ->

    it "can get a trip's vehicle state history in a date range", (done) ->

    # mojios
    it "can get the user's mojios", (done) ->

    it "can get a specific mojio of the user by IMEI", (done) ->

    it "can get a specific mojio of the user by id", (done) ->

    it "can update a specific mojio's details (found by IMEI)", (done) ->

    it "can claim a mojio by IMEI", (done) ->

    it "can unclaim a mojio by IMEI)", (done) ->

    # groups
    it "can create a group for a user", (done) ->

    it "can get the default group for a user", (done) ->

    it "can get all the groups for a user", (done) ->

    it "can add a user to a group", (done) ->

    it "can remove a user from a group", (done) ->

    it "can update a group", (done) ->

    it "can delete a group", (done) ->

    # permissions
    it "can give read permissions to a group to a user", (done) ->

    it "can give write permissions to a group to a user", (done) ->

    it "can give share permissions to a group to a user", (done) ->

    it "can remove read permissions to a group to a user", (done) ->

    it "can remove write permissions to a group to a user", (done) ->

    it "can remove share permissions to a group to a user", (done) ->

    it "can get the user's permissions to a mojio (default group)", (done) ->

    it "can get the user's permissions to a vehicle (default group)", (done) ->

    it "can get the user's permissions to a user (default group)", (done) ->

    it "can get the user's permissions to a trip (default group", (done) ->

    it "can get the user's permissions to a mojio (specific group)", (done) ->

    it "can get the user's permissions to a vehicle (specific group)", (done) ->

    it "can get the user's permissions to a user (specific group)", (done) ->

    it "can get the user's permissions to a trip (specific group", (done) ->

    # tags
    it "can tag a vehicle", (done) ->

    it "can tag a mojio", (done) ->

    it "can tag a user", (done) ->

    it "can tag a trip", (done) ->

    it "can tag a group", (done) ->

    # images
    it "can upload a app image", (done) ->

    it "can upload a vehicle image", (done) ->

    it "can upload a mojio image", (done) ->

    it "can upload a user image", (done) ->

    it "can upload a trip image", (done) ->

    it "can upload a group image", (done) ->

    it "can delete a app image", (done) ->

    it "can delete a vehicle image", (done) ->

    it "can delete a mojio image", (done) ->

    it "can delete a user image", (done) ->

    it "can delete a trip image", (done) ->

    it "can delete a group image", (done) ->