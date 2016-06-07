Base = require 'models/base.coffee'

class DayInTheLife extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    required_nutrients: null
    given_nutrients: null
    # private
    _className: 'DayInTheLife'


  getNetResult: () ->
    result = {}
    for nutrientId in Object.keys @required_nutrients
      givenNutrient = @given_nutrients[nutrientId] ? 0
      result[nutrientId] = givenNutrient - @required_nutrients[nutrientId]
    result

module.exports = DayInTheLife
