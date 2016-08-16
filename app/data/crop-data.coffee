time = require 'services/time-service.coffee'

module.exports =
  grassCrop:
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
  turnipCrop:
    dailyNutrientsNeeded:
      water: 1
      fumono: 1
    harvestables:
      turnip: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  pumpkinCrop:
    dailyNutrientsNeeded:
      water: 1
      fumono: 1
    harvestables:
      pumpkin: amount: 1
    lifeStage:
      child: 2
      adult: 6
      death: 10
    abilities:
      spreader_crop: {}
  tomatoCrop:
    dailyNutrientsNeeded:
      water: 2
      kamono: 1
    harvestables:
      tomato: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  carrotCrop:
    dailyNutrientsNeeded:
      water: 2
      suimono: 1
    harvestables:
      carrot: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
  parsnipCrop:
    dailyNutrientsNeeded:
      water: 1
      chimono: 1
    harvestables:
      parsnip: amount: 3
    lifeStages:
      child: 1
      adult: 4
      death: 6
