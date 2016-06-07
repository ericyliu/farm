$ = require 'jquery'

module.exports =

  start: (game, ViewService) ->
    @inventoryDom = $ '#Inventory'
    @updateItems game.player.items
    ViewService.registerListeners @listeners(), @


  listeners: ->
    'player/itemAdded': @addItem
    'player/itemRemoved': @removeItem
    'item/attributesUpdated': @updateItem


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
