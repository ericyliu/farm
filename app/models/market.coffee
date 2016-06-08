Base = require 'models/base.coffee'

class Market extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Market'
    
    listings: []
    # private


  addListings: (listings) ->
    _.map listings, (listing) =>
      @listings.push listing
      #todo needs dedupe logic
    @set 'listings', @listings


module.exports = Market
