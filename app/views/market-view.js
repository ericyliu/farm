let $ = require('jquery');
let _ = require('lodash');
let EventBus = require('util/event-bus.js');

module.exports = {

  start() {
    this.marketDom = $('#Market');
    this.marketDom.find('a.btn.market-icon').on('click', () => $('#Market').hide());
    return EventBus.registerMany(this.listeners(), this);
  },


  listeners() {
    return {
      'model/Market/listingAdded': this.addListing,
      'model/Market/listingRemoved': this.removeListing,
      'model/Player/itemAdded': this.addItem,
      'model/Player/itemRemoved': this.removeItem,
      'model/Listing/attributesUpdated': this.updateListing,
      'model/Item/attributesUpdated': this.updateItem
    };
  },


  load(game) {
    this.marketDom.find('table.buy').html(createMarketBuyDom(game.market.listings));
    return this.marketDom.find('table.sell').html(createMarketSellDom(game.player.items));
  },


  addListing(listing) {
    return this.marketDom.find('table.buy').append(createListingDom(listing));
  },


  removeListing(listing) {
    return this.marketDom.find(`table.buy .listing#${listing.id}`).remove();
  },


  updateListing(listing) {
    return this.marketDom.find(`table.buy .listing#${listing.id}`).replaceWith(createListingDom(listing));
  },


  addItem(item) {
    return this.marketDom.find('table.sell').append(createItemDom(item));
  },


  removeItem(item) {
    return this.marketDom.find(`table.sell .item#${item.id}`).remove();
  },


  updateItem(item) {
    return this.marketDom.find(`table.sell .item#${item.id}`).replaceWith(createItemDom(item));
  }
};


var createMarketBuyDom = function(listings) {
  let listingDoms = _.map(listings, createListingDom);
  return _.concat([createHeaderDom()], listingDoms);
};

var createListingDom = function(listing) {
  let rowDom = $(`<tr class='listing' id='${listing.id}'>`);
  if (listing.type === 'item') {
    rowDom.append(`\
<td>${listing.item.type}</td>
<td>${listing.item.amount}</td>
<td>${listing.item.quality}</td>\
`
    );
  } else if (listing.type === 'expandFarm') {
    rowDom.append(`\
<td>Expand Your Farm</td>
<td></td>
<td></td>\
`
    );
  } else {
    rowDom.append(`\
<td>${listing.type}</td>
<td></td>
<td></td>\
`
    );
  }
  rowDom.append(`<td>${listing.price}</td>`);
  let buyDom = $('<td><div class="btn">Buy</div></td>')
    .on('click', () => buyListing(listing));
  return rowDom.append(buyDom);
};

var buyListing = listing => EventBus.trigger('controller/Market/buyListing', listing, false);

var createMarketSellDom = function(items) {
  let itemDoms = _.map(items, createItemDom);
  return _.concat([createHeaderDom()], itemDoms);
};

var createItemDom = function(item) {
  let rowDom = $(`\
<tr class='item' id='${item.id}'>
  <td>${item.type}</td>
  <td>${item.amount}</td>
  <td>${item.quality}</td>
  <td>${item.price * item.amount}</td>
</tr>\
`
  );
  let sellDom = $('<td><div class="btn">Sell</div></td>')
    .on('click', () => sellItem(item));
  return rowDom.append(sellDom);
};

var sellItem = item => EventBus.trigger('controller/Market/sellItem', item);

var createHeaderDom = () =>
  $(`\
<tr>
  <th>Name</th>
  <th>Amount</th>
  <th>Quality</th>
  <th>Price</th>
  <th></th>
</tr>\
`
  )
;
