_ = require 'lodash'

class Livable =

  constructor: (@health, @requirements, @harvests) ->
    @lifespan = []


  getYieldOnDeath: ->
    _.filter @harvests, (harvest) -> harvest.cooldown is 0


module.exports = Animal