_ = require 'lodash'
Harvestable = require '../models/harvestable.coffee'
Livable = require '../models/livable.coffee'
Item = require '../models/item.coffee'


data =
  animals: require '../data/animal-data.coffee'
  crops: require '../data/crop-data.coffee'
  items: require '../data/item-data.coffee'

create = (id, type) ->
  return unless data[type]?[id]?
  stats = data[type][id]
  harvestables = _.map stats.harvestables, (harvestable, id) ->
    onDeath = not harvestable.cooldown?
    new Harvestable id, harvestable.amount, harvestable.cooldown, onDeath
  lifeStages = stats.lifeStages
  new Livable id, stats.dailyFoodUsed, harvestables, lifeStages


module.exports =

  createAnimal: (id) -> create id, 'animals'

  createCrop: (id) -> create id, 'crops'

  createItem: (id, amount, quality) -> new Item id, amount, quality

  isItemPlantable: (item) -> data.items[item.type].plantable

  itemToCrop: (item) -> @createCrop data.items[item.type].livable
