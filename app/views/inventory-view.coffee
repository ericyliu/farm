$ = require 'jquery'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: ->
    @inventoryDom = $ '#Inventory'
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/Item/attributesUpdated': @updateItem


  load: (game) ->
    @updateItems game.player.items


  updateItems: (items) ->
    @inventoryDom.html _.map items, (item) -> createItemDom item


  addItem: (item) ->
    @inventoryDom.append createItemDom item


  removeItem: (item) ->
    @inventoryDom.find(".item##{item.id}").remove()


  updateItem: (item) ->
    @inventoryDom.find(".item##{item.id}").replaceWith createItemDom item


createItemDom = (item) ->
  $ "<div class='item #{item.type}' id='#{item.id}'>#{item.type} - #{item.amount} - #{item.quality}</div>"
