_ = require 'lodash'

class Tile

  constructor: (@nutrients = {}, @crop) ->
    @_className = 'Tile'


  update: ->



  addNutrients: (nutrients) ->
    _.map (nutrients), (amount, type) => @addNutrient amount, type


  addNutrient: (amount, type) ->
    return @nutrients[type] = amount unless @nutrients[type]
    @nutrients[type] += amount


  getNutrients: (nutrients) ->
    _.map (nutrients), @getNutrient


  getNutrient: (amount, type) ->
    return 0 unless @nutrients[type]
    # this needs to make sure the tile has enough nutrients
    @nutrients[type] -= amount
    amount


module.exports = Tile
