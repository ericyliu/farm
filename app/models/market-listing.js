let Base = require('models/base.js');

class MarketListing extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'MarketListing',

      item: null,
      type: 'item',
      price: null
    };
  }
}
    // private


module.exports = MarketListing;
