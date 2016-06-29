_ = require 'lodash'
DataService = require 'services/data-service.coffee'
EventBus = require 'util/event-bus.coffee'

class SpreaderPlantController

  constructor: (@gameController) ->


  handleSpreaderPlantDays: (spreaderPlants) ->
    tiles = @getTiles()
    _ spreaderPlants
      .map (plant) ->
        plant.handleSpreaderDay tiles, getCropCoordinate(plant, tiles)
      .flatten()
      .map (tileGroup) ->
        # any conflict resolution for spreader crops would happen here
        crop = DataService.createCrop tileGroup.type
        tile = tileGroup.tile
        if not tile.crop?
          tile.set 'crop', crop
          EventBus.trigger 'model/Farm/cropAdded', tile: tile, crop: crop
      .value()


  getTiles: () ->
    @gameController.game.player.farm.tiles

getCropCoordinate = (crop, tiles) ->
  coordinates = null
  tiles.forEach (tileRow, rowIndex) ->
    tileRow.forEach (tile, colIndex) ->
      tile = tiles[rowIndex][colIndex]
      if tile? and tile.crop? and tile.crop.id is crop.id
        coordinates = rowIndex: rowIndex, colIndex: colIndex
  if not coordinates
    throw new Error "Could not find crop in tiles"
  return coordinates


module.exports = SpreaderPlantController
