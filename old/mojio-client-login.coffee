_MOJIO = require './mojio-client-base'

module.exports = class MOJIO_LOGIN extends _MOJIO

    constructor: (@options) ->
        super(@options)

    ###
        Login
    ###
    login_resource: 'Login'

    _login: (username, password, callback) -> # Use if you want the raw result of the call.
        @Request(
            {
                method: 'POST', resource: @login_resource, id: @options.application,
                parameters:
                    {
                        userOrEmail: username
                        password: password
                        secretKey: @options.secret
                    }
            }, callback
        )

    # Login
    login: (username, password, callback) ->
        @_login(username, password, (error, result) =>
            if (result?)
                @token = result._id
            callback(error, result)
        )


    _logout: (callback) ->
        @Request(
            {
                method: 'DELETE', resource: @login_resource,
                id: if mojio_token? then mojio_token else @token
            }, callback
        )

    # Logout
    logout: (callback) ->
        @_logout((error, result) =>
            @token = null
            callback(error, result)
        )