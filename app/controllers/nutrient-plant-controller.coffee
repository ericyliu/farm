_ = require 'lodash'
DataService = require 'services/data-service.coffee'
EventBus = require 'util/event-bus.coffee'

module.exports =
  handleDays: (spreaderPlants, tiles) ->
    _ spreaderPlants
      .map (plant) ->
        handleDay tiles, getCropCoordinate(plant, tiles), plant
      .flatten()
      .map (tileGroup) ->
        # any conflict resolution for spreader crops would happen here
        crop = DataService.createCrop tileGroup.type
        tile = tileGroup.tile
        tile.addNutrient 1, tileGroup.nutrient
      .value()

# returns {tile: Tile, type: livableType} to indicate which tiles should get crops planted
handleDay = (tiles, cropCoordinate, crop) ->
  if not crop.isAlive()
    return []
  maxDistanceFromTile = 1
  tilesToFertilze = []
  tiles.forEach (tileRow, rowIndex) ->
    tileRow.forEach (tile, colIndex) ->
      tile = tiles[rowIndex][colIndex]
      closeEnough = getTileDistanceAwayFromCoordinate(tile, cropCoordinate, tiles) <= maxDistanceFromTile
      if closeEnough and Math.random() < crop.abilities.nutrient_crop.percent_chance
        nutrient = crop.abilities.nutrient_crop.nutrient
        tilesToFertilze.push({tile: tile, nutrient: nutrient})
  return tilesToFertilze

getTileDistanceAwayFromCoordinate = (tile, coordinate, allTiles) ->
  tileCoordinates = getTileCoordinate tile, allTiles
  rowDistance = Math.abs(tileCoordinates.rowIndex - coordinate.rowIndex)
  colDistance = Math.abs(tileCoordinates.colIndex - coordinate.colIndex)
  Math.max(rowDistance, colDistance)

getTileCoordinate = (tile, allTiles) ->
  coordinate = null
  allTiles.forEach (tileRow, rowIndex) ->
    tileRow.forEach (needleTile, colIndex) ->
      coordinate = rowIndex: rowIndex, colIndex: colIndex if tile is needleTile
  if coordinate then return coordinate else throw new Error "Cannot find tile in farm"


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
