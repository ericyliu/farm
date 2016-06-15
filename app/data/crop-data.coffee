time = require 'services/time-service.coffee'

module.exports =
  grass:
    dailyNutrientsNeeded:
      water: 1
      nitrogen: 1
    harvestables:
      grass: amount: 1
      grassSeed: amount: 2
      dew:
        amount: 1
        cooldown: 5
    lifeStages:
      child: 1
      adult: 2
      death: 3
  turnip:
    dailyNutrientsNeeded:
      water: 1
      fumono: 1
    harvestables:
      turnip: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  tomato:
    dailyNutrientsNeeded:
      water: 2
      kamono: 1
    harvestables:
      tomato: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  carrot:
    dailyNutrientsNeeded:
      water: 2
      suimono: 1
    harvestables:
      carrot: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  parsnip:
    dailyNutrientsNeeded:
      water: 1
      chimono: 1
    harvestables:
      parsnip: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
