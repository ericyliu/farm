$ = require 'jquery'
DataService = require 'services/data-service.coffee'

hideTileMenu = ->
  $('#Farm .tile-menu').css 'visibility', 'hidden'

repositionMenu = (evt) ->
  menuDom = $('#Farm .tile-menu .menu')
  menuDom.css
    'top': _.min [evt.clientY, $(window).height() - menuDom.height() - 20]
    'left': _.min [evt.clientX, $(window).width() - 220]

getMenuDom = (tile) ->
  menuDom = $ """
    <div class='menu'>
      <div class='stats'>
        <div class='stat nitrogen'>N - #{tile.nitrogen}</div>
        <div class='stat water'>W - #{tile.water}</div>
      </div>
    </div>
  """
  if tile.crop then getTileFilledMenu tile, menuDom else getTileEmptyMenu tile, menuDom

getTileFilledMenu = (tile, menuDom) ->
  menuDom.append "<div>Crop: #{tile.crop.type}</div>"

getTileEmptyMenu = (tile, menuDom) ->
  menuDom.append '<div>Plant</div>'
  plantables = _.filter window.Farm.gameController.game.player.items, DataService.isPlantable
  menuDom.append _.map plantables, (item) ->
    itemDom = $ "<div class='btn plant'>#{item.type} x#{item.amount}</div>"
    itemDom.on 'click', -> plant tile, item
    itemDom

plant = (tile, item) ->
  window.Farm.gameController.farmController.plant tile, item
  window.show = true
  hideTileMenu()


module.exports =

  setup: ->
    $('#Farm .tile-menu .background').on 'click', hideTileMenu

  openTileMenu: (evt, tile) ->
    $('#Farm .tile-menu').css 'visibility', 'visible'
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom tile
    repositionMenu evt
