Livable = require 'models/livable.coffee'

describe 'Livable', ->
  beforeEach ->
    @livable = new Livable
      id:'goat'
      dailyNutrientsNeeded:{grass: 1},
      harvestables: [],
      lifeStages: {child: 3}

  describe 'isAlive', ->
    it 'is alive after 0 days', ->
      expect(@livable.isAlive()).to.eql true

    it 'dies if not fed first day', ->
      @livable.handleDay()
      expect(@livable.isAlive()).to.eql false

  describe 'isAlive with feeding', ->
    it 'stays alive with good feeding', ->
      @livable.giveNutrients grass: 1
      @livable.handleDay()
      expect(@livable.isAlive()).to.eql true
      @livable.handleDay()
      expect(@livable.isAlive()).to.eql false

  describe 'giveNutrients', ->
    it 'gets nutrients', ->
      @livable.giveNutrients grass: 3, water: 3
      expect(@livable.getCurrentState()).to.eql grass: 3
      @livable.handleDay()
      expect(@livable.getCurrentState()).to.eql grass: 2
