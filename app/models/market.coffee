Base = require 'models/base.coffee'
EventBus = require 'util/event-bus.coffee'

class Market extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Market'

    listings: []
    # private


  addListing: (listing) ->
    return unless listing?
    @listings.push listing
    EventBus.trigger 'model/Market/listingAdded', listing


  addListings: (listings) ->
    _.map listings, (listing) => @addListing listing


  removeListing: (listing) ->
    return unless listing?
    _.remove @listings, (l) -> l.id is listing.id
    EventBus.trigger 'model/Market/listingRemoved', listing


module.exports = Market
