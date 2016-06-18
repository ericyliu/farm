$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: ->
    @marketDom = $ '#Market'
    @marketDom.find('a.btn.market-icon').on 'click', => $('#Market').hide()
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Market/listingAdded': @addListing
    'model/Market/listingRemoved': @removeListing
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/Listing/attributesUpdated': @updateListing
    'model/Item/attributesUpdated': @updateItem


  load: (game) ->
    @marketDom.find('table.buy').html createMarketBuyDom game.market.listings
    @marketDom.find('table.sell').html createMarketSellDom game.player.items


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
  listingDoms = _.map listings, createListingDom
  _.concat [createHeaderDom()], listingDoms

createListingDom = (listing) ->
  rowDom = $ "<tr class='listing' id='#{listing.id}'>"
  if listing.type is 'item'
    rowDom.append """
      <td>#{listing.item.type}</td>
      <td>#{listing.item.amount}</td>
      <td>#{listing.item.quality}</td>
    """
  else if listing.type is 'expandFarm'
    rowDom.append """
      <td>Expand Your Farm</td>
      <td></td>
      <td></td>
    """
  else
    rowDom.append """
      <td>#{listing.type}</td>
      <td></td>
      <td></td>
    """
  rowDom.append "<td>#{listing.price}</td>"
  buyDom = $('<td><div class="btn">Buy</div></td>')
    .on 'click', -> buyListing listing
  rowDom.append buyDom

buyListing = (listing) ->
  EventBus.trigger 'controller/Market/buyListing', listing, false

createMarketSellDom = (items) ->
  itemDoms = _.map items, createItemDom
  _.concat [createHeaderDom()], itemDoms

createItemDom = (item) ->
  rowDom = $ """
    <tr class='item' id='#{item.id}'>
      <td>#{item.type}</td>
      <td>#{item.amount}</td>
      <td>#{item.quality}</td>
      <td>#{item.price * item.amount}</td>
    </tr>
  """
  sellDom = $('<td><div class="btn">Sell</div></td>')
    .on 'click', -> sellItem item
  rowDom.append sellDom

sellItem = (item) ->
  EventBus.trigger 'controller/Market/sellItem', item

createHeaderDom = ->
  $ """
    <tr>
      <th>Name</th>
      <th>Amount</th>
      <th>Quality</th>
      <th>Price</th>
    </tr>
  """
