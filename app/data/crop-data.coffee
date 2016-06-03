time = require 'services/time-service.coffee'

module.exports =
  grass:
    dailyFoodUsed:
      water: 1
      nitrogen: 1
    harvestables:
      grass: amount: 1
      dew:
        amount: 1
        cooldown: 5
    lifeStages:
      child: time.daysToMinutes 2
      adult: time.daysToMinutes 8
      death: time.daysToMinutes 20
