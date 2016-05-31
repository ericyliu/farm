_ = require 'lodash'

class Tile =

  constructor: () ->
    @water = 0
    @nitrogen = 0

  addWater: (amount) ->
    @water += amount

  addNitrogen: (amount) ->
    @nitrogen += amount

  getWater: () ->
    returnedWater = @water / 3
    @water -= returnedWater
    return returnedWater

module.exports = Animal
