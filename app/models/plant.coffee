_ = require 'lodash'
Livable = require 'models/livable.coffee'
DayInTheLife = require 'models/dayInTheLife.coffee'

class Plant extends Livable

  constructor: (@dailyFoodUsed, @havestables) ->


module.exports = Plant
