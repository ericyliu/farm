let $ = require('jquery');
let DataService = require('services/data-service.js');
let EventBus = require('util/event-bus.js');


let TileMenuView = {

  start() {
    this.items = {};
    return EventBus.registerMany(this.listeners(), this);
  },


  listeners() {
    return {
      'model/Player/itemAdded': this.addItem,
      'model/Player/itemRemoved': this.removeItem,
      'model/Item/attributesUpdated': this.addItem,
      'model/Tile/attributesUpdated': this.updateTile,
      'model/Farm/cropAdded': this.addCrop,
      'model/Farm/cropUpdated': this.updateCrop,
      'model/Harvestable/attributesUpdated': this.updateHarvestable
    };
  },


  load(game) {
    this.items = {};
    _.map(game.player.items, item => {
      return this.items[item.id] = item;
    }
    );
    return this.setup();
  },


  addItem(item) {
    this.items[item.id] = item;
    return this.update();
  },


  removeItem(item) {
    delete this.items[item.id];
    return this.update();
  },


  updateTile(tile) {
    if (tile.id === this.tile.id) {
      updateAttributes(tile, this.tile);
      return this.update();
    }
  },


  addCrop(data) {
    let { tile } = data;
    let { crop } = data;
    if (tile.id === this.tile.id) {
      this.tile.crop = crop;
      return this.update();
    }
  },


  updateCrop(crop) {
    if (this.tile.crop.id === crop.id) {
      updateAttributes(crop, this.tile.crop);
      return this.update();
    }
  },


  updateHarvestable(updatedHarvestable) {
    if ((this.tile == null) || (this.tile.crop == null)) { return; }
    _.map(this.tile.crop.harvestables, function(harvestable) {
      if (harvestable.id === updatedHarvestable.id) {
        return updateAttributes(updatedHarvestable, harvestable);
      }
    });
    return this.update();
  },


  setup() {
    this.open = false;
    return $('#Farm .tile-menu .background').on('click', this.hideTileMenu);
  },


  update() {
    if (!this.open) { return; }
    let menuContainerDom = $('#Farm .tile-menu .menu-container');
    return menuContainerDom.html(getMenuDom(this.tile, this.items));
  },


  openTileMenu(evt, tile) {
    this.open = true;
    this.tile = tile;
    $('#Farm .tile-menu').show();
    let menuContainerDom = $('#Farm .tile-menu .menu-container');
    menuContainerDom.html(getMenuDom(tile, this.items));
    return repositionMenu(evt);
  },


  hideTileMenu() {
    this.open = false;
    return $('#Farm .tile-menu').hide();
  }
};


var repositionMenu = function(evt) {
  let menuDom = $('#Farm .tile-menu .menu-container');
  return menuDom.css({
    'top': _.min([evt.clientY, $(window).height() - menuDom.outerHeight() - 20]),
    'left': _.min([evt.clientX, $(window).width() - menuDom.outerWidth() - 20])});
};

var getMenuDom = function(tile, items) {
  let cropMenu, plantMenu;
  let tileMenu = $('<div class="menu"></div>');
  let statsMenu = getStatsMenu(tile);
  if (tile.crop) {
    cropMenu = getCropMenu(tile);
  } else {
    plantMenu = getPlantMenu(tile, groupItemsByType(items));
  }
  let fertilizerMenu = getFertilizerMenu(tile, groupItemsByType(items));
  let foodMenu = getFoodMenu(tile, groupItemsByType(items));
  return tileMenu.append(_.flatten([statsMenu, cropMenu, plantMenu, fertilizerMenu, foodMenu]));
};

var getStatsMenu = function(tile) {
  let statsMenuDom = $('<div class="stats"><div class="label">Stats:</div></div>');
  return statsMenuDom.append(_.map(tile.nutrients, (amount, nutrient) => $(`<div class='stat ${nutrient}'>${_.toUpper(nutrient[0])} - ${amount}</div>`))
  );
};

var getCropMenu = function(tile) {
  let { crop } = tile;
  let cropDomContainer = $('<div class="label harvests"></div>');
  let cropDoms = [
    $(`<div>Crop: ${crop.type}</div>`).on('click', () => console.log(crop)),
    $('<div class="remove">x</div>').on('click', () => remove(tile))
  ];
  cropDomContainer.append(cropDoms);
  let harvestableDoms = _.map(crop.harvestables, function(harvestable) {
    if (!harvestable.readyForHarvest) { return; }
    return $(`<div class='btn harvest'>${harvestable.type}</div>`)
      .on('click', () => harvest(crop, harvestable));
  });
  return _.concat(cropDomContainer, harvestableDoms);
};

var getPlantMenu = function(tile, item_groups) {
  let plantMenuDom = [$('<div class="label">Plant</div>')];
  let plantable_groups = _.filter(item_groups, item_group => item_group[0].category === 'plantable');
  let plantableDoms = _.map(plantable_groups, function(plantable_group) {
    let plantable = plantable_group[0];
    return $(`<div class='btn plant'>${plantable.type} x ${plantable_group.length}</div>`)
      .on('click', () => plant(tile, plantable));
  });
  return _.concat(plantMenuDom, plantableDoms);
};

var getFertilizerMenu = function(tile, item_groups) {
  let fertilizerMenuDom = [$('<div class="label">Fertilizers</div>')];
  let fertilizer_groups = _.filter(item_groups, item_group => item_group[0].category === 'fertilizer');
  let fertilizerDoms = _.map(fertilizer_groups, fertilizer_group =>
    $(`<div class='btn fertilizer'>${fertilizer_group[0].type} x ${fertilizer_group.length}</div>`)
      .on('click', () => fertilize(tile, fertilizer_group[0])));
  return _.concat(fertilizerMenuDom, fertilizerDoms);
};

var getFoodMenu = function(tile, item_groups) {
  let foodMenuDom = [$('<div class="label">Food</div>')];
  let food_groups = _.filter(item_groups, item_group => item_group[0].category === 'food');
  let foodDoms = _.map(food_groups, function(food_group) {
    let food = food_group[0];
    return $(`<div class='btn fertilizer'>${food.type} x ${food_group.length}</div>`)
      .on('click', () => feed(tile, food));
  });
  return _.concat(foodMenuDom, foodDoms);
};

var harvest = (crop, harvestable) => EventBus.trigger('action/harvest', {livableId: crop.id, harvestableId: harvestable.id});

var plant = (tile, item) => EventBus.trigger('action/plant', {tileId: tile.id, itemId: item.id});

var remove = tile => EventBus.trigger('action/remove', {tileId: tile.id});

var fertilize = (tile, item) => EventBus.trigger('action/fertilize', {tileId: tile.id, itemId: item.id});

var feed = (tile, item) => EventBus.trigger('action/feed', {tileId: tile.id, itemId: item.id});

var updateAttributes = (updatedObject, oldObject) =>
  _.map(updatedObject, (value, key) => oldObject[key] = value)
;

var groupItemsByType = function(items) {
  let reducer = function(result, item) {
    if (!result[item.type]) {
      result[item.type] = [];
    }
    result[item.type].push(item);
    return result;
  };
  return _.reduce(items, reducer, {});
};

module.exports = TileMenuView;
