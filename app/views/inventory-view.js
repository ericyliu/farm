let $ = require('jquery');
let EventBus = require('util/event-bus.js');

module.exports = {

  start() {
    this.itemsDom = $('#Inventory .items');
    $('#Inventory a.btn.inventory-icon').click(toggleInventory);
    return EventBus.registerMany(this.listeners(), this);
  },


  listeners() {
    return {
      'model/Player/itemAdded': this.addItem,
      'model/Player/itemRemoved': this.removeItem,
      'model/Item/attributesUpdated': this.updateItem
    };
  },


  load(game) {
    return this.updateItems(game.player.items);
  },


  updateItems(items) {
    return this.itemsDom.html(_.map(items, item => createItemDom(item)));
  },


  addItem(item) {
    return this.itemsDom.append(createItemDom(item));
  },


  removeItem(item) {
    return this.itemsDom.find(`.item#${item.id}`).remove();
  },


  updateItem(item) {
    return this.itemsDom.find(`.item#${item.id}`).replaceWith(createItemDom(item));
  }
};


var toggleInventory = () => $('#Inventory').hide();

var createItemDom = function(item) {
  let qualityString = (item.quality != null) ? `quality${item.quality}` : "";
  return $(`<div class='item ${item.type}' id='${item.id}'>${item.type}. ${qualityString}</div>`);
};
