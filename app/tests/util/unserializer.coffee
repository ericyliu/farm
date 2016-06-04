Unserializer = require 'util/unserializer.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'
Livable = require 'models/livable.coffee'

class UnserializerTest
  runTests: () ->
    return @testUnserialize()


  testUnserialize: () ->
    livable = new Livable 'goat', {'grass': 1}, [], {'child': 3}
    livable.giveFood {'grass': 4}
    livable.handleDay()
    unserializedLivable = (new Unserializer()).unserialize JSON.parse JSON.stringify livable
    _.isEqual unserializedLivable.getCurrentState(), grass: 3

module.exports = UnserializerTest
