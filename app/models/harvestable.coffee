Base = require 'models/base.coffee'

class Harvestable extends Base

  constructor: (options) ->
    super(options)

    @maxCooldown = @cooldown


  spec: ->
    _className: 'Harvestable'
    
    type: null
    amount: null
    cooldown: null
    onDeath: true
    #private
    maxCooldown: null

module.exports = Harvestable
