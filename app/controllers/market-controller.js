let EventBus = require('util/event-bus.js');
let DataService = require('services/data-service.js');

class MarketController {

  constructor(gameController) {
    this.gameController = gameController;
    this.registerListeners();
  }

  listeners() {
    return {
      'controller/Market/buyListing': this.buyListing,
      'controller/Market/sellItem': this.sellItem
    };
  }


  registerListeners() {
    return EventBus.registerMany(this.listeners(), this);
  }


  buyListing(listing) {
    let player = this.gameController.game.player;
    let market = this.gameController.game.market;
    if (player.money < listing.price) { return; }
    if (listing.type === 'item') {
      player.addItem(listing.item);
    } else if (listing.type === 'expandFarm') {
      player.farm.expand();
      market.removeListing(listing);
      market.addListing(DataService.createExpandFarmListing(player.farm));
    }
    return player.set('money', player.money - listing.price);
  }


  sellItem(item) {
    let { player } = this.gameController.game;
    player.removeItem(item);
    return player.set('money', player.money + (item.amount * item.price));
  }
}


module.exports = MarketController;
