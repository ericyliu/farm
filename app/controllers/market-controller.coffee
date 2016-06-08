EventBus = require 'util/event-bus.coffee'

class MarketController

  constructor: (@gameController) ->
    EventBus.registerMany @listeners(), @


  listeners: ->
    'controller/Market/buyListing': @buyListing
    'controller/Market/sellItem': @sellItem


  buyListing: ({item, price}) ->
    player = @gameController.game.player
    player.addItem item
    player.set 'money', player.money - price


  sellItem: (item) ->
    player = @gameController.game.player
    player.removeItem item
    player.set 'money', player.money + (item.amount * item.price)


module.exports = MarketController
