_ = require 'lodash'

class Livable =

  constructor: (@health, @requirements, @harvests) ->
    @lifespan = []


  getYieldOnDeath: ->
    _.filter @harvests, onDeath


module.exports = Animal
