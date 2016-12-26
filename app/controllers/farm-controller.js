let _ = require('lodash');
let DataService = require('services/data-service.js');
let Tile = require('models/tile.js');
let EventBus = require('util/event-bus.js');
let SpreaderPlantController = require('controllers/spreader-plant-controller.js');
let NutrientPlantController = require('controllers/nutrient-plant-controller.js');
let CropQualityService = require('services/crop-quality-service.js');

class FarmController {
  static initClass() {
  
  
    this.prototype.abilityHandlers = [
      SpreaderPlantController.handleDays,
      NutrientPlantController.handleDays
    ];
  }


  constructor(gameController) {
    this.gameController = gameController;
    this.registerListeners();
  }


  listeners() {
    return {
      'action/plant': this.onPlant,
      'action/fertilize': this.onFertilize,
      'action/feed': this.onFeed,
      'action/harvest': this.onHarvest,
      'action/remove': this.onRemove
    };
  }


  registerListeners() {
    return EventBus.registerMany(this.listeners(), this);
  }


  onPlant(data) {
    let tile = this.getTileWithId(data.tileId);
    let plant = this.getItemWithId(data.itemId);
    return this.plant(tile, plant);
  }


  onRemove(data) {
    let tile = this.getTileWithId(data.tileId);
    return this.removeCrop(tile);
  }


  onFertilize(data) {
    let tile = this.getTileWithId(data.tileId);
    let fertilizer = this.getItemWithId(data.itemId);
    return this.fertilize(tile, fertilizer);
  }


  onFeed(data) {
    let tile = this.getTileWithId(data.tileId);
    let food = this.getItemWithId(data.itemId);
    return this.feed(tile, food);
  }


  onHarvest(data) {
    let livable = this.getLivableWithId(data.livableId);
    let harvestable = _.find(livable.harvestables, harvestable => harvestable.id === data.harvestableId);
    return this.harvest(livable, harvestable);
  }


  plant(tile, item) {
    let crop = DataService.itemToCrop(item);
    tile.set('crop', crop);
    EventBus.trigger('model/Farm/cropAdded', {tile, crop});
    return this.gameController.game.player.removeItem(item, 1);
  }


  fertilize(tile, item) {
    tile.addNutrients(DataService.getNutrients(item));
    return this.gameController.game.player.removeItem(item, 1);
  }


  feed(tile, item) {
    tile.addNutrients(DataService.getFood(item));
    return this.gameController.game.player.removeItem(item, 1);
  }


  harvest(livable, harvestable) {
    let lifespan = _.cloneDeep(livable.lifespan);
    let quality = CropQualityService.calculateCropQuality(lifespan, livable.type);
    let items = DataService.createHarvestedCrops(harvestable.type, quality, lifespan, harvestable.amount);
    this.gameController.game.player.addItems(items);

    return livable.harvest(harvestable);
  }


  removeCrop(tile, livable) {
    tile.set('crop', undefined);
    return EventBus.trigger('model/Farm/cropAdded', {tile, crop: undefined});
  }


  getTileWithId(tileId) {
    let tiles = _.flatten(this.gameController.game.player.farm.tiles);
    let allTiles = _.concat(tiles, this.gameController.getFarm().animalTrough);
    return _.find(allTiles, tile => tile.id === tileId);
  }


  getItemWithId(itemId) {
    let { items } = this.gameController.game.player;
    return _.find(items, item => item.id === itemId);
  }


  getLivableWithId(livableId) {
    return _.find(this.getAllLivables(), livable => livable.id === livableId);
  }


  update() {
    return updateLivables(this.getAllLivables());
  }


  getAllLivables() {
    return _.chain([])
      .concat(this.getAnimals())
      .concat(cropsFromTiles(this.getTiles()))
      .filter()
      .value();
  }


  feedCrops() {
    return _.chain([])
      .concat(this.getTiles())
      .flatten()
      .filter(tile => tile.crop != null)
      .map(function(tile) {
        let { crop } = tile;
        let desiredNutrients = crop.getDesiredNutrients();
        let suppliedNutrients = tile.takeNutrients(desiredNutrients);
        return crop.giveNutrients(suppliedNutrients);
    })
      .value();
  }


  feedAnimals() {
    let { animalTrough } = this.gameController.getFarm();
    return _.chain([])
      .concat(this.getAnimals())
      .map(function(animal) {
        let desiredNutrients = animal.getDesiredNutrients();
        let suppliedNutrients = animalTrough.takeNutrients(desiredNutrients);
        return animal.giveNutrients(suppliedNutrients);
    })
      .value();
  }


  getTiles() {
    return this.gameController.getFarm().tiles;
  }


  getAnimals() {
    return this.gameController.getFarm().animals;
  }


  handleLivableDays(livables) {
    _.map(livables, livable => livable.handleDay());
    return _.map(this.abilityHandlers, handler => {
      return handler(livables, this.getTiles());
    }
    );
  }
}
FarmController.initClass();


var cropsFromTiles = tiles =>
  _.chain(tiles)
    .flatten()
    .map(tile => tile.crop)
    .value()
;


var updateLivables = livables =>
  _.chain(livables)
    .filter()
    .map(livable => livable.update())
    .value()
;


module.exports = FarmController;
