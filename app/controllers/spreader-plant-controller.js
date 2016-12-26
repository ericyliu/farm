let _ = require('lodash');
let DataService = require('services/data-service.js');
let EventBus = require('util/event-bus.js');

module.exports = {
  handleDays(livables, tiles) {
    let spreaderPlants = _.filter(livables, livable => livable.abilities.spreader_crop != null);
    return _(spreaderPlants)
      .map(plant => handleDay(tiles, getCropCoordinate(plant, tiles), plant))
      .flatten()
      .map(function(tileGroup) {
        // any conflict resolution for spreader crops would happen here
        let crop = DataService.createCrop(tileGroup.type);
        let { tile } = tileGroup;
        if (tile.crop == null) {
          tile.set('crop', crop);
          return EventBus.trigger('model/Farm/cropAdded', {tile, crop});
        }
    })
      .value();
  }
};

// returns {tile: Tile, type: livableType} to indicate which tiles should get crops planted
var handleDay = function(tiles, cropCoordinate, crop) {
  if (!crop.isAlive()) {
    return [];
  }
  let maxDistanceFromTile = 1;
  let tilesToPlant = [];
  tiles.forEach((tileRow, rowIndex) =>
    tileRow.forEach(function(tile, colIndex) {
      tile = tiles[rowIndex][colIndex];
      let closeEnough = getTileDistanceAwayFromCoordinate(tile, cropCoordinate, tiles) <= maxDistanceFromTile;
      if (closeEnough && Math.random() < crop.abilities.spreader_crop.percent_chance) {
        return tilesToPlant.push({tile, type: crop.type});
      }
    })
  );
  return tilesToPlant;
};

var getTileDistanceAwayFromCoordinate = function(tile, coordinate, allTiles) {
  let tileCoordinates = getTileCoordinate(tile, allTiles);
  let rowDistance = Math.abs(tileCoordinates.rowIndex - coordinate.rowIndex);
  let colDistance = Math.abs(tileCoordinates.colIndex - coordinate.colIndex);
  return Math.max(rowDistance, colDistance);
};

var getTileCoordinate = function(tile, allTiles) {
  let coordinate = null;
  allTiles.forEach((tileRow, rowIndex) =>
    tileRow.forEach(function(needleTile, colIndex) {
      if (tile === needleTile) { return coordinate = {rowIndex, colIndex}; }
    })
  );
  if (coordinate) { return coordinate; } else { throw new Error("Cannot find tile in farm"); }
};


var getCropCoordinate = function(crop, tiles) {
  let coordinates = null;
  tiles.forEach((tileRow, rowIndex) =>
    tileRow.forEach(function(tile, colIndex) {
      tile = tiles[rowIndex][colIndex];
      if ((tile != null) && (tile.crop != null) && tile.crop.id === crop.id) {
        return coordinates = {rowIndex, colIndex};
      }
    })
  );
  if (!coordinates) {
    throw new Error("Could not find crop in tiles");
  }
  return coordinates;
};
