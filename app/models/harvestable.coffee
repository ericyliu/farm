Base = require 'models/base.coffee'

class Harvestable extends Base

  constructor: (options) ->
    super(options)

    @maxCooldown = @cooldown


  spec: ->
    type: null
    amount: null
    cooldown: null
    onDeath: true
    #private
    _className: 'Harvestable'
    maxCooldown: null

module.exports = Harvestable
