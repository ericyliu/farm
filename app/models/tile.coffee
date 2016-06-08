_ = require 'lodash'
Base = require 'models/base.coffee'

class Tile extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Tile'
      
    nutrients: {}
    crop: null
    # private


  update: ->



  addNutrients: (nutrients) ->
    _.map (nutrients), (amount, type) => @addNutrient amount, type


  addNutrient: (amount, type) ->
    if not @nutrients[type]?
      @nutrients[type] = amount
    else
      @nutrients[type] += amount
    @set('nutrients', @nutrients)


  takeNutrients: (nutrients) ->
    _.mapValues (nutrients), (amount, type) => @takeNutrient(amount, type)


  takeNutrient: (amount, type) ->
    return 0 unless @nutrients[type]
    # this needs to make sure the tile has enough nutrients
    giveAmount = Math.min(amount, @nutrients[type])
    @nutrients[type] -= giveAmount
    @set('nutrients', @nutrients)
    giveAmount


module.exports = Tile
