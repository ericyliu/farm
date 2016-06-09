_ = require 'lodash'
DataService = require 'services/data-service.coffee'
Tile = require 'models/tile.coffee'
EventBus = require 'util/event-bus.coffee'

class FarmController

  constructor: (@gameController) ->
    EventBus.registerMany @listeners(), @


  listeners: ->
    'action/plant': @onPlant
    'action/fertilize': @onFertilize
    'action/feed': @onFeed
    'action/harvest': @onHarvest


  onPlant: (data) ->
    tile = @getTileWithId data.tileId
    plant = @getItemWithId data.itemId
    @plant tile, plant


  onFertilize: (data) ->
    tile = @getTileWithId data.tileId
    fertilizer = @getItemWithId data.itemId
    @fertilize tile, fertilizer


  onFeed: (data) ->
    tile = @getTileWithId data.tileId
    food = @getItemWithId data.itemId
    @feed tile, food


  onHarvest: (data) ->
    livable = @getLivableWithId data.livableId
    harvestable = _.find livable.harvestables, (harvestable) ->
      harvestable.id == data.harvestableId
    @harvest livable, harvestable


  plant: (tile, item) ->
    crop = DataService.itemToCrop item
    tile.set 'crop', crop
    EventBus.trigger 'model/Farm/cropAdded', tile: tile, crop: crop
    @gameController.game.player.removeItem item, 1


  fertilize: (tile, item) ->
    tile.addNutrients DataService.getNutrients item
    @gameController.game.player.removeItem item, 1


  feed: (tile, item) ->
    tile.addNutrients DataService.getFood item
    @gameController.game.player.removeItem item, 1


  harvest: (livable, harvestable) ->
    livable.harvest harvestable
    @gameController.game.player.addItem DataService.createItem harvestable.type, harvestable.amount


  getTileWithId: (tileId) ->
    tiles = _.flatten @gameController.game.player.farm.tiles
    allTiles = _.concat tiles, @gameController.getFarm().animalTrough
    _.find allTiles, (tile) -> tile.id == tileId


  getItemWithId: (itemId) ->
    items = @gameController.game.player.items
    _.find items, (item) -> item.id == itemId


  getLivableWithId: (livableId) ->
    _.find @getAllLivables(), (livable) ->
      livable.id == livableId


  update: ->
    updateLivables @getAllLivables()


  getAllLivables: ->
    _.chain []
      .concat @getAnimals()
      .concat cropsFromTiles @getTiles()
      .filter()
      .value()


  feedCrops: ->
    _.chain []
      .concat @getTiles()
      .flatten()
      .filter (tile) ->
        return tile.crop?
      .map (tile) ->
        crop = tile.crop
        desiredNutrients = crop.getDesiredNutrients()
        suppliedNutrients = tile.takeNutrients desiredNutrients
        crop.giveNutrients suppliedNutrients
      .value()


  feedAnimals: ->
    animalTrough = @gameController.getFarm().animalTrough
    _.chain []
      .concat @getAnimals()
      .map (animal) ->
        desiredNutrients = animal.getDesiredNutrients()
        suppliedNutrients = animalTrough.takeNutrients desiredNutrients
        animal.giveNutrients suppliedNutrients
      .value()


  getTiles: ->
    @gameController.getFarm().tiles


  getAnimals: ->
    @gameController.getFarm().animals


  handleLivableDays: (livables) ->
    _.map livables, (livable) ->
      livable.handleDay()


cropsFromTiles = (tiles) ->
  _.chain tiles
    .flatten()
    .map (tile) -> tile.crop
    .value()


updateLivables = (livables) ->
  _.chain livables
    .filter()
    .map (livable) -> livable.update()
    .value()


module.exports = FarmController
