class DayInTheLife

  constructor: (@required, @given) ->

  getNetResult: () ->
    result = {}
    for foodId in Object.keys @required
      givenFood = @given[foodId] ? 0
      result[foodId] = givenFood - @required[foodId]
    result

module.exports = DayInTheLife
