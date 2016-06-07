Base = require 'models/base.coffee'

class MarketListing extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    item: null
    price: null
    # private
    _className: 'MarketListing'


module.exports = MarketListing
