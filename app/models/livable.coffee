_ = require 'lodash'
DayInTheLife = require 'models/dayInTheLife.coffee'

class Livable

  constructor: (@type, @dailyFoodUsed, @havestables) ->
    # DayInTheLife[]
    @lifespan = []
    @todaysFoodGiven = {}

  getHarvestOnDeath: ->
    _.filter @harvests, onDeath

  handleDay: () ->
    @lifespan.push new DayInTheLife @dailyFoodUsed, @todaysFoodGiven
    @todaysFoodGiven = {}

  giveFood: (allFoodGiven) ->
    for foodId in @getRequiredFoodIds()
      foodGiven = allFoodGiven[foodId] ? 0
      @todaysFoodGiven[foodId] = 0 unless @todaysFoodGiven[foodId]?
      @todaysFoodGiven[foodId] += foodGiven

  getCurrentState: () ->
    requiredFoods = {}
    for foodId in @getRequiredFoodIds()
      requiredFoods[foodId] = 0

    reducer = (result, dayInTheLife, index) =>
      netDayInTheLife = dayInTheLife.getNetResult()
      for foodId in @getRequiredFoodIds()
        result[foodId] += netDayInTheLife[foodId]
      return result
    _.reduce @lifespan, reducer, requiredFoods

  isAlive: () ->
    currentState = @getCurrentState()
    for foodId in @getRequiredFoodIds()
      if currentState[foodId] <= 0
        return false
    true

  getAge: () ->
    @lifespan.length

  getRequiredFoodIds: () ->
    Object.keys @dailyFoodUsed

module.exports = Livable
