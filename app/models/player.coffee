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
    @items[item.id] = item
    EventBus.trigger 'model/Player/itemAdded', item


  addItems: (items) ->
    _.map items, (item) =>
      this.addItem item


  removeItem: (item) ->
    itemToRemove = @items[item.id]
    if not itemToRemove?
      throw new Error("Removing non-existent item #{item.type}")
    delete @items[item.id]
    EventBus.trigger 'model/Player/itemRemoved', item


module.exports = Player
