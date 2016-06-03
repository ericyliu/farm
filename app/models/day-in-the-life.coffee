class DayInTheLife

  constructor: (@required, @given) ->
    @_className = 'DayInTheLife'

  getNetResult: () ->
    result = {}
    for foodId in Object.keys @required
      givenFood = @given[foodId] ? 0
      result[foodId] = givenFood - @required[foodId]
    result

module.exports = DayInTheLife
