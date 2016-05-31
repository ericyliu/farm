_ = require 'lodash'

class Livable

  constructor: (@dailyFoodUsed, @havestables) ->
    # DayInTheLife[]
    @lifespan = []


  getHarvestOnDeath: ->
    _.filter @harvests, onDeath

  handleDay: (foodGiven) ->
    @lifespan.push new DayInTheLife @dailyFoodUsed @foodGiven
    @checkLife

  checkLife: () ->
    

module.exports = Animal
