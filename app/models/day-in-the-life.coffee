class DayInTheLife

  constructor: (@required, @given) ->
    @_className = 'DayInTheLife'

  getNetResult: () ->
    result = {}
    for nutrientId in Object.keys @required
      givenNutrient = @given[nutrientId] ? 0
      result[nutrientId] = givenNutrient - @required[nutrientId]
    result

module.exports = DayInTheLife
