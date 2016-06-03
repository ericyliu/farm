_ = require 'lodash'
DataService = require 'services/data-service.coffee'

cropsFromTiles = (tiles) ->
  _.chain tiles
    .flatten()
    .map (tile) -> tile.crop
    .value()

updateLivables = (farm) ->
  _.chain []
    .concat farm.animals
    .concat cropsFromTiles farm.tiles
    .filter()
    .map (livable) -> livable.update()
    .value()


class FarmController

  constructor: (@gameController) ->


  plant: (tile, item) ->
    tile.crop = DataService.itemToCrop item
    @gameController.game.player.removeItem item


  harvest: (livable, harvestable) ->
    livable.harvest harvestable
    @gameController.game.player.addItem DataService.createItem harvestable.type, harvestable.amount


  update: ->
    updateLivables @gameController.getFarm()


module.exports = FarmController
