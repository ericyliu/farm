_ = require 'lodash'
Harvestable = require '../models/harvestable.coffee'
Livable = require '../models/livable.coffee'
Item = require '../models/item.coffee'
MarketListing = require '../models/market-listing.coffee'


data =
  animals: require '../data/animal-data.coffee'
  crops: require '../data/crop-data.coffee'
  items: require '../data/item-data.coffee'
  farm: require '../data/farm-data.coffee'

create = (id, type) ->
  return unless data[type]?[id]?
  stats = data[type][id]
  harvestables = _.map stats.harvestables, (harvestable, id) ->
    onDeath = not harvestable.cooldown?
    new Harvestable
      type: id
      amount: harvestable.amount
      cooldown: harvestable.cooldown
      onDeath: onDeath
  lifeStages = stats.lifeStages
  new Livable
    type: id
    dailyNutrientsNeeded: stats.dailyNutrientsNeeded
    harvestables: harvestables
    lifeStages: lifeStages


module.exports =

  createAnimal: (id) -> create id, 'animals'

  createCrop: (id) -> create id, 'crops'

  createItem: (id, amount, quality) -> new Item (
    type: id
    amount: amount
    quality: quality
    price: data.items[id].price
  )

  createExpandFarmListing: (farm) ->
    price = data.farm.expandPrices[_.size _.flatten farm.tiles]
    return unless price?
    new MarketListing
      type: 'expandFarm',
      price: price

  isItemFertilizer: (item) -> data.items[item.type].fertilizer

  isItemPlantable: (item) -> data.items[item.type].plantable

  isItemFood: (item) -> data.items[item.type].food

  itemToCrop: (item) -> @createCrop data.items[item.type].livable

  getNutrients: (item) -> data.items[item.type].nutrients

  getFood: (item) -> "#{item.type}": 1

  getPrice: (item) -> (data.items[item.type].price or 1) * item.amount
