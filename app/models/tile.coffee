_ = require 'lodash'

class Tile

  constructor: (@nutrients = {}, @crop) ->
    super()
    @_className = 'Tile'


  update: ->



  addNutrients: (nutrients) ->
    _.map (nutrients), (amount, type) => @addNutrient amount, type


  addNutrient: (amount, type) ->
    return @nutrients[type] = amount unless @nutrients[type]
    @nutrients[type] += amount


  getNutrients: (nutrients) ->
    _.mapValues (nutrients), (amount, type) => @getNutrient(amount, type)


  getNutrient: (amount, type) ->
    return 0 unless @nutrients[type]
    # this needs to make sure the tile has enough nutrients
    giveAmount = Math.min(amount, @nutrients[type])
    @nutrients[type] -= giveAmount
    giveAmount


module.exports = Tile
