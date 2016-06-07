class PlayerController

  constructor: (@gameController) ->


  buy: (item, price) ->
    player = @getPlayer()
    return err: 'Not Enough Money' if player.money < price
    player.addItem item
    player.set 'money', player.money - price


  sell: (item, price) ->
    player = @getPlayer()
    itemToSell = _.find player.items, (playerItem) -> playerItem.type is item.type
    return throw "Not enough of item #{item.type}" if itemToSell?.amount < item.amount
    player.removeItem item
    player.set 'money', player.money + price


  getPlayer: ->
    @gameController.game.player


module.exports = PlayerController
