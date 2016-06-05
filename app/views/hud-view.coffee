$ = require 'jquery'
_ = require 'lodash'
DataService = require 'services/data-service.coffee'
TimeService = require 'services/time-service.coffee'

playbackButtons = []

setPlaybackInfoDom = (playing, speed) ->
  $('#Hud .right .playback-info').html $ """
    <div class='play-status'>#{if playing then 'Playing' else 'Paused'}</div>
    <div class='speed'>x#{speed}</div>
  """

getButtonDoms = ->
  _.map playbackButtons, (button) ->
    $ "<div class='btn'>#{button.label}</div>"
      .on 'click', -> button.method()

getTimeDom = ->
  $ "<div class='time'>Time: #{TimeService.getHumanTime window.Farm.gameController.game.timeElapsed}</div>"

getMoneyDom = ->
  $ "<div class='money'>Gold: #{window.Farm.gameController.game.player.money}</div>"


getPlayerItems = ->
  window.Farm.gameController.game.player.items

getMarketListings = ->
  window.Farm.gameController.game.market.listings


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
    buyDom = $('<td><div class="btn">Buy</div></td>').on 'click', ->
      buyItem listing
    rowDom.append buyDom
  _.concat [getHeaderDom()], rowDoms

getMarketSellDom = (items) ->
  rowDoms = _.map items, (item) ->
    price = DataService.getPrice item
    rowDom = $ """
      <tr>
        <td>#{item.type}</td>
        <td>#{item.amount}</td>
        <td>#{item.quality}</td>
        <td>#{price}</td>
      </tr>
    """
    buyDom = $('<td><div class="btn">Sell</div></td>').on 'click', ->
      sellItem item, price
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

buyItem = (listing) ->
  status = window.Farm.gameController.playerController.buy listing.item, listing.price
  $('#Hud .market .market-status').html status.err if status.err

sellItem = (item, price) ->
  status = window.Farm.gameController.playerController.sell item, price
  $('#Hud .market .market-status').html status.err if status.err


module.exports =

  playSpeed: 1

  setup: ->
    playbackButtons = [
        label: '||'
        method: =>
          window.Farm.gameController.togglePause true
          setPlaybackInfoDom false, @playSpeed
      ,
        label: '>'
        method: =>
          window.Farm.gameController.togglePause false
          f.normalSpeed()
          setPlaybackInfoDom true, 1
          @playSpeed = 1
      ,
        label: '>>'
        method: =>
          window.Farm.gameController.togglePause false
          @playSpeed *= 2
          f.fastForward @playSpeed
          setPlaybackInfoDom true, @playSpeed
      ,
        label: 'Market'
        method: => @toggleMarket true
    ]
    setPlaybackInfoDom true, 1
    $('#Hud .right').append getButtonDoms()
    $('#Hud .market .close').on 'click', => @toggleMarket false


  update: ->
    $('#Hud .status').html [getTimeDom(), getMoneyDom()]
    @updateMarket() if @marketOpen


  updateMarket: ->
    @updateBuyTable()
    @updateSellTable()


  updateBuyTable: ->
    marketListingsHash = JSON.stringify getMarketListings()
    return if @previousListings is marketListingsHash
    $('#Hud .market table.buy').html getMarketBuyDom getMarketListings()
    @previousListings = marketListingsHash


  updateSellTable: ->
    playerItemsHash = JSON.stringify getPlayerItems()
    return if @previousItems is playerItemsHash
    $('#Hud .market table.sell').html getMarketSellDom getPlayerItems()
    @previousItems = playerItemsHash


  toggleMarket: (show) ->
    if show then $('.Hud .market').show()
    else $('.Hud .market').hide()
    @marketOpen = show
