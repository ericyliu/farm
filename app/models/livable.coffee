Base = require 'models/base.coffee'
_ = require 'lodash'
DayInTheLife = require 'models/day-in-the-life.coffee'
Constants = require 'data/constants.coffee'

class Livable extends Base

  ###
  @param string type - the type of livable eg. "goat"
  @param {string nutrientType: int amount} dailyNutrientsNeeded - the nutrient used up by the livable everyday
  @param [harvestable] harvestables - the resources you can get from this livable
  @param {string stage : int days in that stage} lifeStages - the different stages of life that an
    that a given livable has
  ###
  constructor: (options) ->
    super(options)


  spec: ->
    _className: 'Livable'

    type: null
    dailyNutrientsNeeded: null
    harvestables: null
    lifeStages: null
    willEat: null
    #private
    lifespan: [] # DayInTheLife[]
    todaysNutrientsGiven: {}
    wasKilled: false
    lifeStage: Constants.lifeStage.baby
    abilities: []


  update: ->
    updateHarvestables @harvestables
    @getCurrentLifeStage()


  kill: ->
    @set 'wasKilled', true
    @getCurrentLifeStage()


  harvest: (harvestable) ->
    harvestable.reset()
    # muahahaha
    if harvestable.doesKillOnHarvest() then @kill()


  ###
  used to take all the things that happened in a day and save its state.
  also resets the livable for the next day
  ###
  handleDay: () ->
    if not @isAlive() then return
    @lifespan.push (new DayInTheLife required_nutrients: @dailyNutrientsNeeded, given_nutrients: @todaysNutrientsGiven)
    @set 'todaysNutrientsGiven', {}

  ###
  @param {string nutrientType: int amount} allNutrientGiven - the nutrient given to an animal.
    can be called multiple times per day and will get merged together at days end
  ###
  giveNutrients: (allNutrientsGiven) ->
    for nutrientId in @getRequiredNutrientIds()
      nutrientsGiven = allNutrientsGiven[nutrientId] ? 0
      if not @todaysNutrientsGiven[nutrientId]? then @todaysNutrientsGiven[nutrientId] = 0
      @todaysNutrientsGiven[nutrientId] += nutrientsGiven
    @set 'todaysNutrientsGiven', @todaysNutrientsGiven

  ###
  @retrun {sting nutrientType: int amount} the nutrient that the plant wants for the day
  ###
  getDesiredNutrients: () ->
    @dailyNutrientsNeeded


  ###
  @return {string nutrientType: int amount} - the state of a livabele at any given time
  ###
  getCurrentState: () ->
    requiredNutrients = {}
    for nutrientId in @getRequiredNutrientIds()
      todaysNutrients = @todaysNutrientsGiven[nutrientId]
      requiredNutrients[nutrientId] = todaysNutrients ? 0

    reducer = (result, dayInTheLife, index) =>
      netDayInTheLife = dayInTheLife.getNetResult()
      for nutrientId in @getRequiredNutrientIds()
        result[nutrientId] += netDayInTheLife[nutrientId]
      return result
    _.reduce @lifespan, reducer, requiredNutrients


  ###
  Used to determine if a livable is alive. meaning there was never a day when
  one of its requiredNutrient amounts went to 0
  @return bool
  ###
  isAlive: () ->
    if @wasKilled then return false
    if @getAge() == 0 then return true
    currentState = @getCurrentState()
    for nutrientId in @getRequiredNutrientIds()
      if currentState[nutrientId] < 0
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
    if not @isAlive()
      lifeStage = Constants.lifeStage.death
    else
      age = @getAge()
      reducer = (result, lifeStageLength, lifeStage) ->
        if lifeStageLength <= age
          return lifeStage
        else
          result
      lifeStage = _.reduce @lifeStages, reducer, Constants.lifeStage.baby
    if lifeStage != @lifeStage
      @set 'lifeStage', lifeStage
      _.map @harvestables, (harvestable) ->
        harvestable.handleLivableLifeStageChange(lifeStage)
    lifeStage


  getRequiredNutrientIds: () ->
    Object.keys @dailyNutrientsNeeded


updateHarvestables = (harvestables) ->
  _.map harvestables, (harvestable) ->
    harvestable.update()


module.exports = Livable
