Unserializer = require 'util/unserializer.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'
Livable = require 'models/livable.coffee'

describe 'Unserializer', ->
  beforeEach ->
    @unserializer = new Unserializer()

  describe 'unserialize', ->
    beforeEach ->
      @livable = new Livable
        id:'goat'
        dailyNutrientsNeeded:{grass: 1},
        harvestables: [],
        lifeStages: {child: 3}

    it 'unserializes a livable', ->
      @livable.giveNutrients {'grass': 4}
      @livable.handleDay()
      unserializedLivable = @unserializer.unserialize JSON.parse JSON.stringify @livable
      expect(unserializedLivable.getCurrentState()).to.eql grass: 3
