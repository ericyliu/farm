_ = require 'lodash'
Harvestable = require 'models/harvestable.coffee'
Livable = require 'models/livable.coffee'
Item = require 'models/item.coffee'
MarketListing = require 'models/market-listing.coffee'


data =
  animals: require 'data/animal-data.coffee'
  crops: require 'data/crop-data.coffee'
  items: require 'data/item-data.coffee'
  farm: require 'data/farm-data.coffee'

createLivable = (id, type) ->
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
    abilities: data[type][id].abilities

DataService =
  createAnimal: (id) -> createLivable id, 'animals'

  createCrop: (id) -> createLivable id, 'crops'

  createItem: (id) -> new Item (
    type: id
    category: data.items[id].category
  )

  createItems: (id, amount) ->
    items = []
    for n in [0..amount]
      items.push(this.createItem(id))
    return items

  createHarvestedCrop: (id, quality, lifespan) -> new Item (
    type: id
    quality: quality
    price: data.items[id].price
    category: data.items[id].category
    lifespan: lifespan
  )

  createHarvestedCrops: (id, quality, lifespan, amount) ->
    crops = []
    for n in [1..amount]
      crops.push(this.createHarvestedCrop(id, quality, lifespan))
    return crops

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

module.exports = DataService
