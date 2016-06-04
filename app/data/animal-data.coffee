time = require 'services/time-service.coffee'

module.exports =
  goat:
    dailyFoodUsed:
      water: 3
      grass: 3
    harvestables:
      meat:
        amount: 10
      milk:
        amount: 1
        cooldown: time.daysToMinutes 1
      manure:
        amount: 3
        cooldown: time.daysToMinutes 1
    lifeStages:
      child: 1
      adult: 2
      death: 3
