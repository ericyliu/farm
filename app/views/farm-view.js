let $ = require('jquery');
let TileMenuView = require('views/tile-menu-view.js');
let EventBus = require('util/event-bus.js');

module.exports = {

  start() {
    this.fieldDom = $('#Farm .field');
    this.penDom = $('#Farm .pen');
    this.show = 'farm';
    return EventBus.registerMany(this.listeners(), this);
  },


  listeners() {
    return {
      'model/Farm/fieldUpdated': this.updateField,
      'model/Farm/animalAdded': this.addAnimal,
      'model/Farm/expanded': this.onFarmExpanded,
      'model/Tile/attributesUpdated': this.updateTile,
      'model/Livable/attributesUpdated': this.updateLivable,
      'model/Farm/cropAdded': this.addCrop,
      'model/Harvestable/attributesUpdated': this.updateHarvestable
    };
  },


  load(game) {
    this.tiles = game.player.farm.tiles;
    this.animals = game.player.farm.animals;
    this.animalTrough = game.player.farm.animalTrough;
    this.updateField(this.tiles);
    return this.updatePen(this.animals);
  },


  updateField(tiles) {
    return this.fieldDom.find('.tiles').html(_.map(tiles, createFieldRowDom));
  },


  onFarmExpanded(tiles) {
    this.tiles = tiles;
    return this.updateField(this.tiles);
  },


  updatePen(animals) {
    return this.penDom.html(_.map(animals, animal => this.createAnimalDom(animal)));
  },


  updateTile(updatedTile) {
    let tiles = _.concat(_.flatten(this.tiles), this.animalTrough);
    _.map(tiles, function(tile) {
      if (tile.id === updatedTile.id) { return updateAttributes(updatedTile, tile); }
    });
    return this.updateField(this.tiles);
  },


  addAnimal(animal) {
    return this.penDom.append(createAnimalDom(animal));
  },


  updateLivable(livable) {
    _(this.tiles)
      .flatten()
      .filter(tile => (tile.crop != null) && tile.crop.id === livable.id)
      .map(tile => updateAttributes(livable, tile.crop))
      .value();
    return this.updateField(this.tiles);
  },


  addCrop(data) {
    let updatedTile = data.tile;
    let { crop } = data;
    _(this.tiles)
      .flatten()
      .filter(tile => tile.id === updatedTile.id)
      .map(tile => tile.crop = crop)
      .value();
    return this.updateField(this.tiles);
  },


  updateHarvestable(updatedHarvestable) {
    return _(this.tiles)
      .flatten()
      .filter(tile => (tile.crop != null) && (tile.crop.harvestables != null))
      .map(tile =>
        _.map(tile.crop.harvestables, function(harvestable) {
          if (harvestable.id === updatedHarvestable.id) {
            return updateAttributes(updatedHarvestable, harvestable);
          }
        })
    )
      .value();
  },


  createAnimalDom(animal) {
    let animalDom = $(`<div class='animal ${animal.type}' id='${animal.id}'></div>`);
    let { animalTrough } = this;
    return animalDom.on('click', evt => TileMenuView.openTileMenu(evt, animalTrough));
  }
};



var createFieldRowDom = row => $("<div class='row'></div>").append(_.map(row, createTileDom));

var createTileDom = function(tile) {
  let tileDom = $(`<div class='tile' id='${tile.id}'>`);
  if (tile.crop != null) { tileDom.append(createCropDom(tile.crop)); }
  _.map(tile.nutrients, function(amt, nutrient) {
    if (amt > 0) { return tileDom.append($(`<div class='nutrient ${nutrient}'>`)); }
  });
  tileDom.on('click', evt => TileMenuView.openTileMenu(evt, tile));
  return tileDom;
};

var createCropDom = function(crop) {
  let cropClass = `crop ${crop.type} life-stage-${crop.lifeStage}`;
  return $(`<div class='${cropClass}' id='${crop.id}'></div>`);
};

var updateAttributes = (updatedObject, oldObject) =>
  _.map(updatedObject, (value, key) => oldObject[key] = value)
;
