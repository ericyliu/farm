Unserializer = require 'util/unserializer.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'
Livable = require 'models/livable.coffee'

describe 'Unserializer', ->
  beforeEach ->
    @unserializer = new Unserializer()

  describe 'unserialize', ->
    beforeEach ->
      @livable = new Livable 'goat', {'grass': 1}, [], {'child': 3}

    it 'unserializes a livable', ->
      @livable.giveNutrients {'grass': 4}
      @livable.handleDay()
      unserializedLivable = @unserializer.unserialize JSON.parse JSON.stringify @livable
      expect(unserializedLivable.getCurrentState()).to.eql grass: 3
