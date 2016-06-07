Base = require 'models/base.coffee'
_ = require 'lodash'
DayInTheLife = require 'models/day-in-the-life.coffee'

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
    type: null
    dailyNutrientsNeeded: null
    harvestables: null
    lifeStages: null
    willEat: null
    #private
    lifespan: [] # DayInTheLife[]
    _className: 'Livable'
    todaysNutrientsGiven: {}
    wasKilled: false


  update: ->
    updateHarvestables @harvestables


  getHarvestsReady: ->
    _.filter @harvestables, (harvestable) -> harvestable.cooldown is 0


  getHarvestOnDeath: ->
    _.filter @harvestables, onDeath


  harvest: (harvestable) ->
    harvestable.set 'cooldown', harvestable.maxCooldown


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
    if not @isAlive() then return 'death'
    age = @getAge()
    reducer = (result, lifeStageLength, lifeStage) ->
      if lifeStageLength <= age
        return lifeStage
      else
        result
    _.reduce @lifeStages, reducer, 'baby'


  getRequiredNutrientIds: () ->
    Object.keys @dailyNutrientsNeeded


updateHarvestables = (harvestables) ->
  _.map harvestables, (harvestable) ->
    return unless harvestable?.maxCooldown and harvestable.cooldown > 0
    harvestable.cooldown -= 1


module.exports = Livable
