_ = require 'lodash'

class Tile

  constructor: (@water = 0, @nitrogen = 0, @crop) ->

  addWater: (amount) ->
    @water += amount

  addNitrogen: (amount) ->
    @nitrogen += amount

  getWater: () ->
    returnedWater = Math.floor @water / 3
    @water -= returnedWater
    returnedWater

  getNitrigen: () ->
    returnedNitrigen = Math.floor @nitrogen / 3
    @nitrogen -= returnedNitrigen;
    returnedNitrigen

module.exports = Tile
