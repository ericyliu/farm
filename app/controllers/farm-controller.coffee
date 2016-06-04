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
    updateLivables @getAllLivables()


  getAllLivables: ->
    _.chain []
    .concat @gameController.getFarm().animals
    .concat cropsFromTiles @gameController.getFarm().tiles
    .filter()
    .value()


  handleLivableDays: (livables) ->
    _.map livables, (livable) ->
      livable.handleDay()



module.exports = FarmController
