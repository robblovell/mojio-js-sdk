# version 0.0.1
MojioPushSDK = require './MojioPushSDK'

module.exports = class MojioSDK extends MojioPushSDK

    # Construct a MojioSDK object.
    #
    # @param [object] options Configurable options for the sdk.
    constructor: (options={}) ->
        super(options)