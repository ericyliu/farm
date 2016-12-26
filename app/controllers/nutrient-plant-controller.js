let _ = require('lodash');
let DataService = require('services/data-service.js');
let EventBus = require('util/event-bus.js');

module.exports = {
  handleDays(livables, tiles) {
    let nutrientPlants = _.filter(livables, livable => livable.abilities.nutrient_crop != null);
    return _(nutrientPlants)
      .map(plant => handleDay(tiles, getCropCoordinate(plant, tiles), plant))
      .flatten()
      .map(function(tileGroup) {
        // any conflict resolution for spreader crops would happen here
        let crop = DataService.createCrop(tileGroup.type);
        let { tile } = tileGroup;
        return tile.addNutrient(1, tileGroup.nutrient);
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
  let tilesToFertilze = [];
  tiles.forEach((tileRow, rowIndex) =>
    tileRow.forEach(function(tile, colIndex) {
      tile = tiles[rowIndex][colIndex];
      let closeEnough = getTileDistanceAwayFromCoordinate(tile, cropCoordinate, tiles) <= maxDistanceFromTile;
      if (closeEnough && Math.random() < crop.abilities.nutrient_crop.percent_chance) {
        let { nutrient } = crop.abilities.nutrient_crop;
        return tilesToFertilze.push({tile, nutrient});
      }
    })
  );
  return tilesToFertilze;
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
