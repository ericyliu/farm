_ = require 'lodash'
DataService = require 'services/data-service.coffee'
Tile = require 'models/tile.coffee'

class FarmController

  constructor: (@gameController) ->
    @animalTrough = new Tile()


  plant: (tile, item) ->
    tile.set 'crop', DataService.itemToCrop item
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
    animalTrough = @animalTrough
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
