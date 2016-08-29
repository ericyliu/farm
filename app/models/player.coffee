_ = require 'lodash'
Base = require 'models/base.coffee'
EventBus = require 'util/event-bus.coffee'

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
      existingItem.set 'amount', existingItem.amount + item.amount
    else
      @items[item.type] = item
      EventBus.trigger 'model/Player/itemAdded', item


  removeItem: (item, amount) ->
    itemToRemove = @items[item.type]
    if not itemToRemove?
      throw new Exception("Removing non-existent item #{item.type}")
    else if itemToRemove.amount < amount
      throw new Exception("Removing more of an item than exists #{item.type}")
    if not amount? or itemToRemove.amount is amount
      delete @items[item.type]
      EventBus.trigger 'model/Player/itemRemoved', item
    else
      itemToRemove.set 'amount', itemToRemove.amount - amount


module.exports = Player
