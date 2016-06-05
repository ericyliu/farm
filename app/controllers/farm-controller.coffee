_ = require 'lodash'
DataService = require 'services/data-service.coffee'

cropsFromTiles = (tiles) ->
  _.chain tiles
    .flatten()
    .map (tile) -> tile.crop
    .value()


updateLivables = (livables) ->
  _.chain []
    .concat livables
    .filter()
    .map (livable) -> livable.update()


class FarmController

  constructor: (@gameController) ->


  plant: (tile, item) ->
    tile.crop = DataService.itemToCrop item
    @gameController.game.player.removeItem item


  fertilize: (tile, item) ->
    tile.addNutrients DataService.getNutrients item
    @gameController.game.player.removeItem item


  harvest: (livable, harvestable) ->
    livable.harvest harvestable
    @gameController.game.player.addItem DataService.createItem harvestable.type, harvestable.amount


  update: ->
    updateLivables @getAllLivables()


  getAllLivables: ->
    _.chain []
      .concat @gameController.getFarm().animals
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
        suppliedNutrients = tile.getNutrients desiredNutrients
        crop.giveNutrients suppliedNutrients
      .value()


  getTiles: ->
    @gameController.getFarm().tiles


  handleLivableDays: (livables) ->
    _.map livables, (livable) ->
      livable.handleDay()



module.exports = FarmController
