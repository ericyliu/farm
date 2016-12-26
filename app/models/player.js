let _ = require('lodash');
let Base = require('models/base.js');
let EventBus = require('util/event-bus.js');

class Player extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Player',

      name: null,
      farm: null,
      money: 0,
      items: {}
    };
  }
    // private


  addItem(item) {
    this.items[item.id] = item;
    return EventBus.trigger('model/Player/itemAdded', item);
  }


  addItems(items) {
    return _.map(items, item => {
      return this.addItem(item);
    }
    );
  }


  removeItem(item) {
    let itemToRemove = this.items[item.id];
    if (itemToRemove == null) {
      throw new Error(`Removing non-existent item ${item.type}`);
    }
    delete this.items[item.id];
    EventBus.trigger('model/Player/itemRemoved', item);
  }
}


module.exports = Player;
