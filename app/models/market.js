let Base = require('models/base.js');
let EventBus = require('util/event-bus.js');

class Market extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Market',

      listings: []
    };
  }
    // private


  addListing(listing) {
    if (listing == null) { return; }
    this.listings.push(listing);
    return EventBus.trigger('model/Market/listingAdded', listing);
  }


  addListings(listings) {
    return _.map(listings, listing => this.addListing(listing));
  }


  removeListing(listing) {
    if (listing == null) { return; }
    _.remove(this.listings, l => l.id === listing.id);
    return EventBus.trigger('model/Market/listingRemoved', listing);
  }
}


module.exports = Market;
