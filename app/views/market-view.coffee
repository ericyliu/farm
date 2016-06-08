$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: (game) ->
    @marketDom = $ '#Market'
    @marketDom.find('.close').on 'click', => $('#Market').hide()
    @marketDom.find('table.buy').html createMarketBuyDom game.market.listings
    @marketDom.find('table.sell').html createMarketSellDom game.player.items
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Market/listingAdded': @addListing
    'model/Market/listingRemoved': @removeListing
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/listing/attributesUpdated': @updateListing
    'model/item/attributesUpdated': @updateItem


  addListing: (listing) ->
    @marketDom.find('table.buy').append createListingDom listing


  removeListing: (listing) ->
    @marketDom.find("table.buy .listing##{listing.id}").remove()


  updateListing: (listing) ->
    @marketDom.find("table.buy .listing##{listing.id}").replaceWith createListingDom listing


  addItem: (item) ->
    @marketDom.find('table.sell').append createItemDom item


  removeItem: (item) ->
    @marketDom.find("table.sell .item##{item.id}").remove()


  updateItem: (item) ->
    @marketDom.find("table.sell .item##{item.id}").replaceWith createItemDom item


createMarketBuyDom = (listings) ->
  rowDoms = _.map listings, createListingDom
  _.concat [createHeaderDom()], rowDoms

createListingDom = (listing) ->
  rowDom = $ """
    <tr class='listing' id='#{listing.id}'>
      <td>#{listing.item.type}</td>
      <td>#{listing.item.amount}</td>
      <td>#{listing.item.quality}</td>
      <td>#{listing.price}</td>
    </tr>
  """
  buyDom = $('<td><div class="btn">Buy</div></td>')
  rowDom.append buyDom

createMarketSellDom = (items) ->
  rowDoms = _.map items, createItemDom
  _.concat [createHeaderDom()], rowDoms

createItemDom = (item) ->
  rowDom = $ """
    <tr class='item' id='#{item.id}'>
      <td>#{item.type}</td>
      <td>#{item.amount}</td>
      <td>#{item.quality}</td>
      <td>#{item.price * item.amount}</td>
    </tr>
  """
  buyDom = $('<td><div class="btn">Sell</div></td>')
  rowDom.append buyDom

createHeaderDom = ->
  $ """
    <tr>
      <th>Name</th>
      <th>Amount</th>
      <th>Quality</th>
      <th>Price</th>
    </tr>
  """
