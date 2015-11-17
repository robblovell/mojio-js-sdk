module.exports = class MojioValidator

    constructor: () ->

    # OAuth2 validators
    scopes: ['basic','full','admin','read', 'write', 'delete', 'create', 'legacy', 'sandbox', 'restricted']
    validateScope: (scopes) ->
        for scope in scopes
            if scope not in @scopes
                return "Scope is not valid for authentication: #{scope}"
        return true

    credentials: (params) ->
        if (params.redirect_url? or params.redirect_uri? or params.redirect? or params.redirectUrl? or
                params.return_url? or params.return? or params.returnUrl?)
            return true
        if (params.user? or params.username? or params.email? or params.usernameoremail? ) and
                (params.password? or params.pass?)
            (params['username'] = params.user; delete params.user) if params.user?
            (params['username'] = params.email; delete params.email) if params.email?
            (params['username'] = params.usernameoremail; delete params.usernameoremail) if params.usernameoremail?
            (params['password'] = params.pass; delete params.pass) if params.pass?
            return true
        else
            throw "Must specify a username or email and a password when using 'password' or 'implicit' type OAuth2 authorization"

    OAuthBody: (params) ->
        (params.client_id = params.app_id; delete params.app_id) if (params.app_id?)
        (params.response_type = params.type; delete params.type) if (params.type?)
        switch params.response_type
            when 'code'
                if (params.redirect_url? or params.redirect_uri? orparams.redirect? or params.redirectUrl? or
                        params.return_url? or params.return? or params.returnUrl?)
                    (params['redirect_uri'] = params.redirect_url; delete params.redirect_url) if params.redirect_url?
                    (params['redirect_uri'] = params.redirect; delete params.redirect) if params.redirect?
                    (params['redirect_uri'] = params.redirectUrl; delete params.redirectUrl) if params.redirectUrl?
                    (params['redirect_uri'] = params.return_uri; delete params.return_uri) if params.return_uri?
                    (params['redirect_uri'] = params.return_url; delete params.return_url) if params.return_url?
                    (params['redirect_uri'] = params.return; delete params.return) if params.return?
                    (params['redirect_uri'] = params.returnUrl; delete params.returnUrl) if params.returnUrl?
                    return true
                else
                    throw "Must specify a return url (returnUrl or redirectUrl) field when using 'code' type OAuth2 authorization"
            when 'password', 'implicit'
                haveUser = ''
                if (params.authorization_code?)
                    return true
                if (params.user? or params.username? or params.email? or params.usernameoremail? ) and
                        (params.password? or params.pass?)
                    (params['username'] = params.user; delete params.user) if params.user?
                    (params['username'] = params.email; delete params.email) if params.email?
                    (params['username'] = params.usernameoremail; delete params.usernameoremail) if params.usernameoremail?
                    (params['password'] = params.pass; delete params.pass) if params.pass?
                    return true
                else
                    throw "Must specify a username or email and a password when using 'password' or 'implicit' type OAuth2 authorization!!"
            else
                throw "When authorizing, you must specify response_type = password, implicit, or code authorization."
    validateState: (params) ->
        switch params.operation
            when 'authorize' or 'token'
                return true
            when 'get' or 'put' or 'post' or 'delete' or 'query' or 'retreive' or 'create' or 'destroy'
                return true

            else
                return 'Must Specify an operation: authorize, get, put, post, delete, query, retreive, create, destroy.'







