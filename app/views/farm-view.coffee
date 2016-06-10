$ = require 'jquery'
TileMenuView = require 'views/tile-menu-view.coffee'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: ->
    @fieldDom = $ '#Farm .field'
    @penDom = $ '#Farm .pen'
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Farm/fieldUpdated': @updateField
    'model/Farm/animalAdded': @addAnimal
    'model/Farm/expanded': @onFarmExpanded
    'model/Tile/attributesUpdated': @updateTile
    'model/Livable/attributesUpdated': @updateLivable
    'model/Farm/cropAdded': @addCrop
    'model/Harvestable/attributesUpdated': @updateHarvestable


  load: (game) ->
    @tiles = game.player.farm.tiles
    @animals = game.player.farm.animals
    @animalTrough = game.player.farm.animalTrough
    @updateField @tiles
    @updatePen @animals


  updateField: (tiles) ->
    @fieldDom.html _.map tiles, createFieldRowDom


  onFarmExpanded: (tiles) ->
    @tiles = tiles
    @updateField @tiles


  updatePen: (animals) ->
    @penDom.html _.map animals, (animal) => @createAnimalDom(animal)


  updateTile: (updatedTile) ->
    tiles = _.concat _.flatten(@tiles), @animalTrough
    _.map tiles, (tile) ->
      if tile.id == updatedTile.id then updateAttributes updatedTile, tile


  addAnimal: (animal) ->
    @penDom.append createAnimalDom animal


  updateLivable: (livable) ->
    _ @tiles
      .flatten()
      .map (tile) -> if tile.crop? and tile.crop.id = livable.id then updateAttributes livable, tile.crop
      .value()
    @updateField @tiles


  addCrop: (data) ->
    updatedTile = data.tile
    crop = data.crop
    _ @tiles
      .flatten()
      .filter (tile) -> tile.id == updatedTile.id
      .map (tile) -> tile.crop = crop
      .value()
    @updateField @tiles


  updateHarvestable: (updatedHarvestable) ->
    _ @tiles
      .flatten()
      .filter (tile) ->
        tile.crop? and tile.crop.harvestables?
      .map (tile) ->
        _.map tile.crop.harvestables, (harvestable) ->
          if harvestable.id == updatedHarvestable.id
            updateAttributes updatedHarvestable, harvestable
      .value()


  createAnimalDom: (animal) ->
    animalDom = $ "<div class='animal #{animal.type}' id='#{animal.id}'>#{animal.type}</div>"
    animalTrough = @animalTrough
    animalDom.on 'click', (evt) -> TileMenuView.openTileMenu evt, animalTrough


createFieldRowDom = (row) ->
  $("<div class='row'></div>").append _.map row, createTileDom

createTileDom = (tile) ->
  tileDom = $ "<div class='tile' id='#{tile.id}'>"
  tileDom.append createCropDom tile.crop if tile.crop?
  tileDom.on 'click', (evt) -> TileMenuView.openTileMenu evt, tile
  tileDom

createCropDom = (crop) ->
  cropClass = "crop #{crop.type} life-stage-#{crop.lifeStage}"
  $ "<div class='#{cropClass}' id='#{crop.id}'></div>"

updateAttributes = (updatedObject, oldObject) ->
  _.map updatedObject, (value, key) ->
    oldObject[key] = value
