$ = require 'jquery'

getItemDom = (item) ->
  "<div class='item #{item.type}'>#{item.type} - #{item.amount}</div>"

module.exports =

  update: ->
    items = window.Farm.gameController.game.player.items
    return if @previousItems is JSON.stringify items
    inventoryView = $ '#Inventory'
    itemDoms = _.map items, getItemDom
    inventoryView.html _.join itemDoms
    @previousItems = JSON.stringify items