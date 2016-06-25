Base = require 'models/base.coffee'
Constants = require 'data/constants.coffee'

class Harvestable extends Base

  constructor: (options) ->
    super(options)

    @maxCooldown = @cooldown


  spec: ->
    _className: 'Harvestable'

    type: null
    amount: null
    readyForHarvest: false
    #private
    cooldown: null
    maxCooldown: null


  # this harvestable requires killing the plant (like picking a tomato)
  doesKillOnHarvest: ->
    not @maxCooldown?


  reset: ->
    if @maxCooldown? then @set 'cooldown', @maxCooldown
    @set 'readyForHarvest', false


  update: ->
    if @maxCooldown? and @cooldown > 0
      @set 'cooldown', @cooldown - 1
      if @cooldown is 0 then @set 'readyForHarvest', true


  handleLivableLifeStageChange: (lifeStage) ->
    if lifeStage is Constants.lifeStage.adult and @doesKillOnHarvest()
      @set 'readyForHarvest', true


module.exports = Harvestable
