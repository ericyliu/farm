Base = require 'models/base.coffee'

class MarketListing extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'MarketListing'

    item: null
    type: 'item'
    price: null
    # private


module.exports = MarketListing
