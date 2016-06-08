Base = require 'models/base.coffee'

class MarketListing extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'MarketListing'
    
    item: null
    price: null
    # private


module.exports = MarketListing
