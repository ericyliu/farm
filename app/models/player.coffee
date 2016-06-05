_ = require 'lodash'

class Player

  constructor: (@name, @farm, @money = 0, @items = []) ->
    @_className = 'Player'


  addItem: (item) ->
    existingItem = _.find @items, (i) -> i.type is item.type and i.quality is i.quality
    return existingItem.amount += item.amount if existingItem
    @items = _.concat @items, item


  removeItem: (item, amount) ->
    itemToRemove = _.find @items, (playerItem) -> playerItem.type is item.type
    return unless itemToRemove
    itemToRemove.amount -= amount or item.amount
    _.remove @items, itemToRemove if itemToRemove.amount <= 0


module.exports = Player
