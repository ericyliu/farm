$ = require 'jquery'
DataService = require 'services/data-service.coffee'

repositionMenu = (evt) ->
  menuDom = $('#Farm .tile-menu .menu-container')
  menuDom.css
    'top': _.min [evt.clientY, $(window).height() - menuDom.height() - 20]
    'left': _.min [evt.clientX, $(window).width() - 220]

getMenuDom = (tile) ->
  tileMenu = $ '<div class="menu"></div>'
  statsMenu = getStatsMenu tile
  if tile.crop
    cropMenu = getCropMenu tile.crop
  else
    plantMenu = getPlantMenu tile
    fertilizerMenu = getFertilizerMenu tile
  tileMenu.append _.flatten [statsMenu, cropMenu, plantMenu, fertilizerMenu]

getStatsMenu = (tile) ->
  statsMenuDom = $ '<div class="stats"><div>Stats:</div></div>'
  statsMenuDom.append _.map tile.nutrients, (amount, nutrient) ->
    $ "<div class='stat #{nutrient}'>#{_.toUpper nutrient[0]} - #{amount}</div>"

getCropMenu = (crop) ->
  cropDoms = [
    $("<div>Crop: #{crop.type}</div>")
      .on 'click', -> console.log crop
  ]
  harvestableDoms = _.map crop.harvestables, (harvestable) ->
    return unless harvestable.cooldown is 0
    $ "<div class='btn harvest'>#{harvestable.type} x#{harvestable.amount}</div>"
      .on 'click', -> harvest crop, harvestable
  _.concat cropDoms, harvestableDoms

getPlantMenu = (tile) ->
  plantMenuDom = [$ '<div>Plant</div>']
  plantables = _.filter window.Farm.gameController.game.player.items, DataService.isItemPlantable
  plantableDoms = _.map plantables, (item) ->
    $ "<div class='btn plant'>#{item.type} x#{item.amount}</div>"
      .on 'click', -> plant tile, item
  _.concat plantMenuDom, plantableDoms

getFertilizerMenu = (tile) ->
  fertilizerMenuDom = [$ '<div>Fertilizers</div>']
  fertilizers = _.filter window.Farm.gameController.game.player.items, DataService.isItemFertilizer
  fertilizerDoms = _.map fertilizers, (item) ->
    $ "<div class='btn fertilizer'>#{item.type} x#{item.amount}</div>"
      .on 'click', -> fertilize tile, item
  _.concat fertilizerMenuDom, fertilizerDoms

harvest = (crop, harvestable) ->
  window.Farm.gameController.farmController.harvest crop, harvestable

plant = (tile, item) ->
  window.Farm.gameController.farmController.plant tile, item

fertilize = (tile, item) ->
  window.Farm.gameController.farmController.fertilize tile, item


module.exports =

  setup: ->
    @open = false
    $('#Farm .tile-menu .background').on 'click', @hideTileMenu


  update: ->
    return unless @open
    tileHash = JSON.stringify @tile
    return if @previousTile is tileHash
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom @tile
    @previousTile = tileHash


  openTileMenu: (evt, tile) ->
    @open = true
    @tile = tile
    $('#Farm .tile-menu').css 'visibility', 'visible'
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom tile
    repositionMenu evt


  hideTileMenu: ->
    @open = false
    $('#Farm .tile-menu').css 'visibility', 'hidden'
