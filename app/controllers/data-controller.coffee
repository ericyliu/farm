_ = require 'lodash'
Harvestable = require '../models/harvestable.coffee'
Livable = require '../models/livable.coffee'


data =
  animals: require '../data/animal-data.coffee'
  plants: require '../data/plant-data.coffee'

create = (id, type) ->
  return unless data[type]?[id]?
  stats = data[type][id]
  harvestables = _.map stats.harvestables, (harvestable, id) ->
    onDeath = not harvestable.cooldown?
    new Harvestable id, harvestable.amount, harvestable.cooldown, onDeath
  new Livable id, stats.dailyFoodUsed, harvestables


module.exports =

  createAnimal: (id) -> create id, 'animals'

  createPlant: (id) -> create id, 'plants'
