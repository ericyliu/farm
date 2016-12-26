let EventBus = require('util/event-bus.js');
let $ = require('jquery');

let views = [
  require('views/hud-view.js'),
  require('views/inventory-view.js'),
  require('views/farm-view.js'),
  require('views/tile-menu-view.js'),
  require('views/market-view.js'),
  require('views/day-end-view.js')
];

module.exports = {

  start() {
    EventBus.registerMany(this.listeners(), this);
    _.map(views, view => view.start());
    return this.tryConnectionInterval = setInterval((() => EventBus.trigger('controller/Game/onViewConnect')), 1000);
  },


  listeners() {
    return {
      'controller/Game/onViewConnected': this.onConnected,
      'controller/Game/gameLoaded': this.loadGame
    };
  },


  loadGame(game) {
    return _.map(views, view => view.load(game));
  },


  onConnected(data) {
    clearInterval(this.tryConnectionInterval);
    return this.loadGame(data);
  }
};
