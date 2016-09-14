$ = require 'jquery'
DataService = require 'services/data-service.coffee'
EventBus = require 'util/event-bus.coffee'


TileMenuView =

  start: ->
    @items = {}
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Player/itemAdded': @addItem
    'model/Player/itemRemoved': @removeItem
    'model/Item/attributesUpdated': @addItem
    'model/Tile/attributesUpdated': @updateTile
    'model/Farm/cropAdded': @addCrop
    'model/Farm/cropUpdated': @updateCrop
    'model/Harvestable/attributesUpdated': @updateHarvestable


  load: (game) ->
    @items = {}
    _.map game.player.items, (item) =>
      @items[item.id] = item
    @setup()


  addItem: (item) ->
    @items[item.id] = item
    @update()


  removeItem: (item) ->
    delete @items[item.id]
    @update()


  updateTile: (tile) ->
    if tile.id == @tile.id
      updateAttributes tile, @tile
      @update()


  addCrop: (data) ->
    tile = data.tile
    crop = data.crop
    if tile.id == @tile.id
      @tile.crop = crop
      @update()


  updateCrop: (crop) ->
    if @tile.crop.id == crop.id
      updateAttributes crop, @tile.crop
      @update()


  updateHarvestable: (updatedHarvestable) ->
    return if not @tile? or not @tile.crop?
    _.map @tile.crop.harvestables, (harvestable) ->
      if harvestable.id == updatedHarvestable.id
        updateAttributes updatedHarvestable, harvestable
    @update()


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
    $('#Farm .tile-menu').show()
    menuContainerDom = $('#Farm .tile-menu .menu-container')
    menuContainerDom.html getMenuDom tile, @items
    repositionMenu evt


  hideTileMenu: ->
    @open = false
    $('#Farm .tile-menu').hide()


repositionMenu = (evt) ->
  menuDom = $('#Farm .tile-menu .menu-container')
  menuDom.css
    'top': _.min [evt.clientY, $(window).height() - menuDom.outerHeight() - 20]
    'left': _.min [evt.clientX, $(window).width() - menuDom.outerWidth() - 20]

getMenuDom = (tile, items) ->
  tileMenu = $ '<div class="menu"></div>'
  statsMenu = getStatsMenu tile
  if tile.crop
    cropMenu = getCropMenu tile
  else
    plantMenu = getPlantMenu tile, groupItemsByType(items)
  fertilizerMenu = getFertilizerMenu tile, groupItemsByType(items)
  foodMenu = getFoodMenu tile, groupItemsByType(items)
  tileMenu.append _.flatten [statsMenu, cropMenu, plantMenu, fertilizerMenu, foodMenu]

getStatsMenu = (tile) ->
  statsMenuDom = $ '<div class="stats"><div class="label">Stats:</div></div>'
  statsMenuDom.append _.map tile.nutrients, (amount, nutrient) ->
    $ "<div class='stat #{nutrient}'>#{_.toUpper nutrient[0]} - #{amount}</div>"

getCropMenu = (tile) ->
  crop = tile.crop
  cropDomContainer = $('<div class="label harvests"></div>')
  cropDoms = [
    $("<div>Crop: #{crop.type}</div>").on 'click', -> console.log crop
    $('<div class="remove">x</div>').on 'click', -> remove tile
  ]
  cropDomContainer.append cropDoms
  harvestableDoms = _.map crop.harvestables, (harvestable) ->
    return unless harvestable.readyForHarvest
    $ "<div class='btn harvest'>#{harvestable.type}</div>"
      .on 'click', -> harvest crop, harvestable
  _.concat cropDomContainer, harvestableDoms

getPlantMenu = (tile, item_groups) ->
  plantMenuDom = [$ '<div class="label">Plant</div>']
  plantable_groups = _.filter item_groups, (item_group) -> item_group[0].category == 'plantable'
  plantableDoms = _.map plantable_groups, (plantable_group) ->
    plantable = plantable_group[0]
    $ "<div class='btn plant'>#{plantable.type} x #{plantable_group.length}</div>"
      .on 'click', -> plant tile, plantable
  _.concat plantMenuDom, plantableDoms

getFertilizerMenu = (tile, item_groups) ->
  fertilizerMenuDom = [$ '<div class="label">Fertilizers</div>']
  fertilizer_groups = _.filter item_groups, (item_group) ->
    item_group[0].category == 'fertilizer'
  fertilizerDoms = _.map fertilizer_groups, (fertilizer_group) ->
    $ "<div class='btn fertilizer'>#{fertilizer_group[0].type} x #{fertilizer_group.length}</div>"
      .on 'click', -> fertilize tile, fertilizer_group[0]
  _.concat fertilizerMenuDom, fertilizerDoms

getFoodMenu = (tile, item_groups) ->
  foodMenuDom = [$ '<div class="label">Food</div>']
  food_groups = _.filter item_groups, (item_group) -> item_group[0].category == 'food'
  foodDoms = _.map food_groups, (food_group) ->
    food = food_group[0]
    $ "<div class='btn fertilizer'>#{food.type} x #{food_group.length}</div>"
      .on 'click', -> feed tile, food
  _.concat foodMenuDom, foodDoms

harvest = (crop, harvestable) ->
  EventBus.trigger 'action/harvest', livableId: crop.id, harvestableId: harvestable.id

plant = (tile, item) ->
  EventBus.trigger 'action/plant', tileId: tile.id, itemId: item.id

remove = (tile) ->
  EventBus.trigger 'action/remove', tileId: tile.id

fertilize = (tile, item) ->
  EventBus.trigger 'action/fertilize', tileId: tile.id, itemId: item.id

feed = (tile, item) ->
  EventBus.trigger 'action/feed', tileId: tile.id, itemId: item.id

updateAttributes = (updatedObject, oldObject) ->
  _.map updatedObject, (value, key) ->
    oldObject[key] = value

groupItemsByType = (items) ->
  reducer = (result, item) ->
    if not result[item.type]
      result[item.type] = []
    result[item.type].push item
    return result
  return _.reduce items, reducer, {}

module.exports = TileMenuView
