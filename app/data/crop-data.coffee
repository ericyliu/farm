time = require 'services/time-service.coffee'

module.exports =
  grass:
    dailyNutrientsNeeded:
      water: 1
      nitrogen: 1
    harvestables:
      grass: amount: 1
      dew:
        amount: 1
        cooldown: 5
    lifeStages:
      child: 1
      adult: 2
      death: 3
