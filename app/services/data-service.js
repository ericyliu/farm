let _ = require('lodash');
let Harvestable = require('models/harvestable.js');
let Livable = require('models/livable.js');
let Item = require('models/item.js');
let MarketListing = require('models/market-listing.js');


let data = {
  animals: require('data/animal-data.js'),
  crops: require('data/crop-data.js'),
  items: require('data/item-data.js'),
  farm: require('data/farm-data.js')
};

let createLivable = function(id, type) {
  if (__guard__(data[type], x => x[id]) == null) { return; }
  let stats = data[type][id];
  let harvestables = _.map(stats.harvestables, function(harvestable, id) {
    let onDeath = (harvestable.cooldown == null);
    return new Harvestable({
      type: id,
      amount: harvestable.amount,
      cooldown: harvestable.cooldown,
      onDeath
    });
  });
  let { lifeStages } = stats;
  return new Livable({
    type: id,
    dailyNutrientsNeeded: stats.dailyNutrientsNeeded,
    harvestables,
    lifeStages,
    abilities: data[type][id].abilities
  });
};

let DataService = {
  createAnimal(id) { return createLivable(id, 'animals'); },

  createCrop(id) { return createLivable(id, 'crops'); },

  createItem(id) {
    let input = {
      type: id,
      category: data.items[id].category
    };
    return new Item(input);
  },

  createItems(id, amount) {
    let items = [];
    for (let n of __range__(0, amount, true)) {
      items.push(this.createItem(id));
    }
    return items;
  },

  createHarvestedCrop(id, quality, lifespan) {
    let input = {
      type: id,
      quality,
      price: data.items[id].price,
      category: data.items[id].category,
      lifespan
    };
    return new Item(input);
  },

  createHarvestedCrops(id, quality, lifespan, amount) {
    let crops = [];
    for (let n of __range__(1, amount, true)) {
      crops.push(this.createHarvestedCrop(id, quality, lifespan));
    }
    return crops;
  },

  createExpandFarmListing(farm) {
    let price = data.farm.expandPrices[_.size(_.flatten(farm.tiles))];
    if (price == null) { return; }
    return new MarketListing({
      type: 'expandFarm',
      price
    });
  },

  isItemFertilizer(item) { return data.items[item.type].fertilizer; },

  isItemPlantable(item) { return data.items[item.type].plantable; },

  isItemFood(item) { return data.items[item.type].food; },

  itemToCrop(item) { return this.createCrop(data.items[item.type].livable); },

  getNutrients(item) { return data.items[item.type].nutrients; },

  getFood(item) { return {[item.type]: 1}; },

  getPrice(item) { return (data.items[item.type].price || 1) * item.amount; }
};

module.exports = DataService;

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}
function __range__(left, right, inclusive) {
  let range = [];
  let ascending = left < right;
  let end = !inclusive ? right : ascending ? right + 1 : right - 1;
  for (let i = left; ascending ? i < end : i > end; ascending ? i++ : i--) {
    range.push(i);
  }
  return range;
}