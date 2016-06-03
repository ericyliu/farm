_ = require 'lodash'
Livable = require 'models/livable.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'

class Plant extends Livable

  constructor: (@dailyFoodUsed, @havestables) ->
    @_className = 'Plant'


module.exports = Plant
