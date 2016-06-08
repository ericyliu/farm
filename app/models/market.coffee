Base = require 'models/base.coffee'
EventBus = require 'util/event-bus.coffee'

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
      EventBus.trigger 'model/Market/listingAdded', listing
      #todo needs dedupe logic


module.exports = Market
