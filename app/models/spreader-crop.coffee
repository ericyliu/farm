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
    maxDistanceFromTile = 1
    tilesToPlant = []
    tiles.forEach (tileRow, rowIndex) ->
      tileRow.forEach (tile, colIndex) ->
        tile = tiles[rowIndex][colIndex]
        closeEnough = getTileDistanceAwayFromCoordinate(tile, thisCropCoordinate, tiles) <= maxDistanceFromTile
        tileIsWorthy = Math.random() < 0.5
        if closeEnough and tileIsWorthy
          tilesToPlant.push({tile: tile, type: self.type})
    return tilesToPlant

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



module.exports = SpreaderCrop
