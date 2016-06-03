_ = require 'lodash'
DayInTheLife = require 'models/day-in-the-life.coffee'

class Livable

  ###
  @param string type - the type of livable eg. "goat"
  @param {string foodType: int amount} dailyFoodUsed - the food used up by the livable everyday
  @param [harvestable] harvestables - the resources you can get from this livable
  @param {string stage : int days in that stage} lifeStages - the different stages of life that an
    that a given livable has
  ###
  constructor: (@type, @dailyFoodUsed, @havestables, @lifeStages) ->
    # DayInTheLife[]
    @lifespan = []
    @todaysFoodGiven = {}
    @_className = 'Livable'

  getHarvestOnDeath: ->
    _.filter @harvests, onDeath

  ###
  used to take all the things that happened in a day and save its state.
  also resets the livable for the next day
  ###
  handleDay: () ->
    @lifespan.push new DayInTheLife @dailyFoodUsed, @todaysFoodGiven
    @todaysFoodGiven = {}

  ###
  @param {string foodType: int amount} allFoodGiven - the food given to an animal.
    can be called multiple times per day and will get merged together at days end
  ###
  giveFood: (allFoodGiven) ->
    for foodId in @getRequiredFoodIds()
      foodGiven = allFoodGiven[foodId] ? 0
      @todaysFoodGiven[foodId] = 0 unless @todaysFoodGiven[foodId]?
      @todaysFoodGiven[foodId] += foodGiven

  ###
  @return {string foodType: int amount} - the state of a livabele at any given time
  ###
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

  ###
  Used to determine if a livable is alive. meaning there was never a day when
  one of its requiredFood amounts went to 0
  @return bool
  ###
  isAlive: () ->
    currentState = @getCurrentState()
    for foodId in @getRequiredFoodIds()
      if currentState[foodId] <= 0
        return false
    true

  ###
  @return int - the age of the livable in days
  ###
  getAge: () ->
    @lifespan.length

  ###
  @return string - the current life stage of a livable
  ###
  getCurrentLifeStage: () ->
    age = @getAge()
    currentLifeStage = 'baby'
    _.forOwn @lifeStages, (lifeStageLength, lifeStage) ->
      age -= lifeStageLength
      currentLifeStage = lifeStage if age >= 0
    currentLifeStage

  getRequiredFoodIds: () ->
    Object.keys @dailyFoodUsed

module.exports = Livable
