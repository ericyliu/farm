Base = require 'models/base.coffee'
_ = require 'lodash'

class Player extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Player'

    name: null
    farm: null
    money: 0
    items: {}
    # private


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
    itemToRemove.set 'amount', itemToRemove.amount - amount


module.exports = Player
