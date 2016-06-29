_ = require 'lodash'
Livable = require 'models/livable.coffee'
Constants = require 'data/constants.coffee'

class SpreaderCrop extends Livable

  constructor: (options) ->
    newSpec = _.mergeWith @spec(), @childSpec(), (specObj, childSpecObj, key, spec, childSpec) ->
      if specObj? and childSpecObj? #implies that spec and childSpec have the same key
        console.info "Child model overwriting parent model key [#{key}] in model [#{childSpec[key]}]"
      return undefined
    @spec = () -> newSpec
    super(options)


  childSpec: ->
    isSpreaderCrop: true

  # returns {tile: Tile, type: livableType} to indicate which tiles should get crops planted
  handleSpreaderDay: (tiles, thisCropCoordinate) ->
    if not @isAlive()
      return []
    self = @
    distanceFromTile = 1
    tilesToPlant = []
    tiles.forEach (tileRow, rowIndex) ->
      tileRow.forEach (tile, colIndex) ->
        tile = tiles[rowIndex][colIndex]
        if tileIsDistanceAwayFromCoordinate tile, distanceFromTile, thisCropCoordinate, tiles
          tilesToPlant.push({tile: tile, type: self.type})
    return tilesToPlant

tileIsDistanceAwayFromCoordinate = (tile, distance, coordinate, allTiles) ->
  tileCoordinates = getTileCoordinate tile, allTiles
  rowInRange = Math.abs(tileCoordinates.rowIndex - coordinate.rowIndex) <= distance
  colInRange = Math.abs(tileCoordinates.colIndex - coordinate.colIndex) <= distance
  return rowInRange and colInRange

getTileCoordinate = (tile, allTiles) ->
  coordinate = null
  allTiles.forEach (tileRow, rowIndex) ->
    tileRow.forEach (needleTile, colIndex) ->
      coordinate = rowIndex: rowIndex, colIndex: colIndex if tile is needleTile
  if coordinate then return coordinate else throw new Error "Cannot find tile in farm"



module.exports = SpreaderCrop
