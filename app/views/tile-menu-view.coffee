$ = require 'jquery'
DataService = require 'services/data-service.coffee'
EventBus = require 'util/event-bus.coffee'


TileMenuView =

  start: (game) ->
    @items = {}
    _.map game.player.items, (item) =>
      @items[item.id] = item
    EventBus.registerMany @listeners(), @
    @setup()


  listeners: ->
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/Item/attributesUpdated': @updateItem
    'model/Tile/attributesUpdated': @updateTile
    'model/Farm/cropAdded': @addCrop
    'model/Farm/cropUpdated': @updateCrop


  addItem: (item) ->
    @items[item.id] = item
    @update()


  removeItem: (item) ->
    delete @items[item.id]
    @update()


  updateItem: (item) ->
    @items[item.id] = item
    @update()


  updateTile: (tile) ->
    if tile.id == @tile.id
      @tile = tile
      @update()


  addCrop: (data) ->
    tile = data.tile
    crop = data.crop
    if tile.id == @tile.id
      @tile.crop = crop


  updateCrop: (crop) ->
    debugger
    if @tile.crop.id == crop.id
      @tile.crop = crop


  setup: ->
    @open = false
    $('#Farm .tile-menu .background').on 'click', @hideTileMenu


  update: ->
    return unless @open
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom @tile, @items


  openTileMenu: (evt, tile) ->
    @open = true
    @tile = tile
    $('#Farm .tile-menu').css 'visibility', 'visible'
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom tile, @items
    repositionMenu evt


  hideTileMenu: ->
    @open = false
    $('#Farm .tile-menu').css 'visibility', 'hidden'


  addItem: (item) ->
    @items.push item


repositionMenu = (evt) ->
  menuDom = $('#Farm .tile-menu .menu-container')
  menuDom.css
    'top': _.min [evt.clientY, $(window).height() - menuDom.height() - 20]
    'left': _.min [evt.clientX, $(window).width() - 220]

getMenuDom = (tile, items) ->
  tileMenu = $ '<div class="menu"></div>'
  statsMenu = getStatsMenu tile
  if tile.crop
    cropMenu = getCropMenu tile.crop
  else
    plantMenu = getPlantMenu tile, items
  fertilizerMenu = getFertilizerMenu tile, items
  foodMenu = getFoodMenu tile, items
  tileMenu.append _.flatten [statsMenu, cropMenu, plantMenu, fertilizerMenu, foodMenu]

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

getPlantMenu = (tile, items) ->
  plantMenuDom = [$ '<div>Plant</div>']
  plantables = _.filter items, (item) -> item.category == 'plantable'
  plantableDoms = _.map plantables, (item) ->
    $ "<div class='btn plant'>#{item.type} x#{item.amount}</div>"
      .on 'click', -> plant tile, item
  _.concat plantMenuDom, plantableDoms

getFertilizerMenu = (tile, items) ->
  fertilizerMenuDom = [$ '<div>Fertilizers</div>']
  fertilizers = _.filter items, (item) -> item.category == 'fertilizer'
  fertilizerDoms = _.map fertilizers, (item) ->
    $ "<div class='btn fertilizer'>#{item.type} x#{item.amount}</div>"
      .on 'click', -> fertilize tile, item
  _.concat fertilizerMenuDom, fertilizerDoms

getFoodMenu = (tile, items) ->
  foodMenuDom = [$ '<div>Food</div>']
  foods = _.filter items, (item) -> item.category == 'food'
  foodDoms = _.map foods, (item) ->
    $ "<div class='btn fertilizer'>#{item.type} x#{item.amount}</div>"
      .on 'click', -> feed tile, item
  _.concat foodMenuDom, foodDoms

harvest = (crop, harvestable) ->
  EventBus.trigger('action/harvest', {tileId: tile.id, itemId: item.id})

plant = (tile, item) ->
  EventBus.trigger('action/plant', {tileId: tile.id, itemId: item.id})

fertilize = (tile, item) ->
  EventBus.trigger('action/fertilize', {tileId: tile.id, itemId: item.id})

feed = (tile, item) ->
  EventBus.trigger('action/feed', {tileId: tile.id, itemId: item.id})


module.exports = TileMenuView
