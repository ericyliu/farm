$ = require 'jquery'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: ->
    @itemsDom = $ '#Inventory .items'
    $('#Inventory a.btn.inventory-icon').click toggleInventory
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/Item/attributesUpdated': @updateItem


  load: (game) ->
    @updateItems game.player.items


  updateItems: (items) ->
    @itemsDom.html _.map items, (item) -> createItemDom item


  addItem: (item) ->
    @itemsDom.append createItemDom item


  removeItem: (item) ->
    @itemsDom.find(".item##{item.id}").remove()


  updateItem: (item) ->
    @itemsDom.find(".item##{item.id}").replaceWith createItemDom item


toggleInventory = ->
  $('#Inventory').hide()

createItemDom = (item) ->
  $ "<div class='item #{item.type}' id='#{item.id}'>#{item.type}, q#{item.quality} - x#{item.amount}</div>"
