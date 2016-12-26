let DataService = require('services/data-service.js');
let Game = require('models/game.js');
let MarketListing = require('models/market-listing.js');
let Tile = require('models/tile.js');
let Unserializer = require('util/unserializer.js');
let EventBus = require('util/event-bus.js');

let FarmController = require('controllers/farm-controller.js');
let PlayerController = require('controllers/player-controller.js');
let MarketController = require('controllers/market-controller.js');

class GameController {

  constructor() {
    this.game = new Game();
    this.controllers = {
      farm: new FarmController(this),
      player: new PlayerController(this),
      market: new MarketController(this)
    };
    givePlayerStartingItems(this.game.player);
    populateMarket(this.game);
    EventBus.registerMany(this.listeners(), this);
  }


  listeners() {
    return {
      'controller/Game/endDay': this.endDay,
      'controller/Game/pause': () => this.paused = true,
      'controller/Game/unpause': () => this.paused = false,
      'controller/Game/onViewConnect': this.onViewConnected
    };
  }


  update() {
    if (this.paused) { return; }
    this.game.set('timeElapsed', this.game.timeElapsed + 1);
    this.controllers.farm.update();
    if (isEndOfDay(this.game)) {
      this.controllers.farm.feedCrops();
      this.controllers.farm.feedAnimals();
      return this.controllers.farm.handleLivableDays(this.controllers.farm.getAllLivables());
    }
  }


  onViewConnected() {
    return EventBus.trigger('controller/Game/onViewConnected', this.game);
  }


  endDay() {
    let minutesInDay = 24 * 60;
    let startOfDay = _.floor(this.game.timeElapsed / minutesInDay) * minutesInDay;
    let nextDayAt7 = startOfDay + ((7 + 24) * 60);
    let minutesUntilNextDayAt7 = nextDayAt7 - this.game.timeElapsed;
    for (let x = 0; x < minutesUntilNextDayAt7; x++) {
      this.update();
    }
    this.paused = true;
    return EventBus.trigger('controller/Game/dayEnded');
  }


  getFarm() {
    return this.game.player.farm;
  }


  togglePause() {
    return this.paused = !this.paused;
  }


  saveGame() {
    console.log(this.game);
    localStorage.setItem('game-save', JSON.stringify(this.game));
    return EventBus.trigger('game/save');
  }


  loadGame() {
    let savedState = JSON.parse(localStorage.getItem('game-save'));
    this.game = (new Unserializer()).unserialize(savedState);
    console.log(this.game);
    return EventBus.trigger('controller/Game/gameLoaded', this.game);
  }
}


module.exports = GameController;


let createStartingFarm = () =>
  _.map(_.range(5), () =>
    _.map(_.range(5), () => new Tile())
  )
;

var givePlayerStartingItems = function(player) {
  player.farm.animals = [ DataService.createAnimal('goat') ];
  player.farm.tiles = createStartingFarm();
  player.money = 100;
  let startItems = _.flatten([
    DataService.createItems('grassSeed', 5),
    DataService.createItems('goatManure', 5),
    DataService.createItems('wateringCan', 5),
    DataService.createItems('grass', 5),
    DataService.createItems('turnipSeed', 5),
    DataService.createItems('pumpkinSeed', 5),
    DataService.createItems('soybeanSeed', 5),
    DataService.createItems('fumonoFertilizer', 10),
    DataService.createItems('kamonoFertilizer', 10),
    DataService.createItems('suimonoFertilizer', 10),
    DataService.createItems('chimonoFertilizer', 10)
  ]);
  return _.map(startItems, item => player.addItem(item));
};

var isEndOfDay = game => game.timeElapsed !== 0 && game.timeElapsed % (60 * 24) === 0;

var populateMarket = game =>
  game.market.addListings([
    new MarketListing({ item: DataService.createItem('grassSeed', 3), price: 10 }),
    new MarketListing(DataService.createExpandFarmListing(game.player.farm))
  ])
;
