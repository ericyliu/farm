EventBus = require 'util/event-bus.coffee'
DataService = require 'services/data-service.coffee'

class MarketController

  constructor: (@gameController) ->
    EventBus.registerMany @listeners(), @


  listeners: ->
    'controller/Market/buyListing': @buyListing
    'controller/Market/sellItem': @sellItem


  buyListing: (listing) ->
    player = @gameController.game.player
    market = @gameController.game.market
    return if player.money < listing.price
    if listing.type is 'item'
      player.addItem listing.item
    else if listing.type is 'expandFarm'
      player.farm.expand()
      market.removeListing listing
      market.addListing DataService.createExpandFarmListing player.farm
    player.set 'money', player.money - listing.price


  sellItem: (item) ->
    player = @gameController.game.player
    player.removeItem item
    player.set 'money', player.money + (item.amount * item.price)


module.exports = MarketController
