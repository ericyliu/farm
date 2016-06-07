_ = require 'lodash'

class Player

  constructor: (@name, @farm, @money = 0, @items = {}) ->
    super()
    @_className = 'Player'


  addItem: (item) ->
    existingItem = @items[item.type]
    if existingItem?
      existingItem.amount += item.amount
    else
      @items[item.type] = item


  removeItem: (item, amount) ->
    itemToRemove = @items[item.type]
    if not itemToRemove?
      throw "Removing non-existent item #{item.type}"
    else if itemToRemove.amount < amount
      throw "Removing more of an item than exists #{item.type}"
    itemToRemove -= amount


module.exports = Player
