class PlayerController

  constructor: (@gameController) ->


  buy: (item, price) ->
    player = @getPlayer()
    return err: 'Not Enough Money' if player.money < price
    player.addItem item
    player.money -= price


  sell: (item, price) ->
    player = @getPlayer()
    itemToSell = _.find player.items, (playerItem) -> playerItem.type is item.type
    return err: 'Not enough of item' if itemToSell?.amount < item.amount
    player.removeItem item
    player.money += price


  getPlayer: ->
    @gameController.game.player


module.exports = PlayerController

