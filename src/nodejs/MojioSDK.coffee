# version 0.0.1

MojioPushSDK = require './MojioPushSDK'

module.exports = class MojioSDK extends MojioPushSDK

    constructor: (options={}) ->
        super(options)