$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: (game) ->
    $('#Market .close').on 'click', => $('#Market').hide()
    $('#Market table.buy').html getMarketBuyDom game.market.listings
    $('#Market table.sell').html getMarketSellDom game.player.items
    EventBus.registerMany @listeners(), @


  listeners: ->


getMarketBuyDom = (listings) ->
  rowDoms = _.map listings, (listing) ->
    rowDom = $ """
      <tr>
        <td>#{listing.item.type}</td>
        <td>#{listing.item.amount}</td>
        <td>#{listing.item.quality}</td>
        <td>#{listing.price}</td>
      </tr>
    """
    buyDom = $('<td><div class="btn">Buy</div></td>')
    rowDom.append buyDom
  _.concat [getHeaderDom()], rowDoms

getMarketSellDom = (items) ->
  rowDoms = _.map items, (item) ->
    rowDom = $ """
      <tr>
        <td>#{item.type}</td>
        <td>#{item.amount}</td>
        <td>#{item.quality}</td>
        <td>#{item.price}</td>
      </tr>
    """
    buyDom = $('<td><div class="btn">Sell</div></td>')
    rowDom.append buyDom
  _.concat [getHeaderDom()], rowDoms

getHeaderDom = ->
  $ """
    <tr>
      <th>Name</th>
      <th>Amount</th>
      <th>Quality</th>
      <th>Price</th>
    </tr>
  """
