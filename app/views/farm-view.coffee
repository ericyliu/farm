$ = require 'jquery'
TileMenuView = require 'views/tile-menu-view.coffee'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: (game) ->
    @fieldDom = $ '#Farm .field'
    @penDom = $ '#Farm .pen'
    @tiles = game.player.farm.tiles
    @animals = game.player.farm.animals
    @updateField @tiles
    @updatePen @animals
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Farm/fieldUpdated': @updateField
    'model/Farm/animalAdded': @addAnimal
    'model/Farm/expanded': @updateField
    'model/Tile/attributesUpdated': @updateTile
    'model/Crop/attributesUpdated': @updateLivable
    'model/Animal/attributesUpdated': @updateLivable
    'model/Farm/cropAdded': @addCrop
    'model/Harvestable/attributesUpdated': @updateHarvestable


  updateField: (tiles) ->
    @fieldDom.html _.map tiles, createFieldRowDom


  updatePen: (animals) ->
    @penDom.html _.map animals, createAnimalDom


  updateTile: (updatedTile) ->
    _.map @tiles, (tileRow) ->
      _.map tileRow, (tile) ->
        if tile.id == updatedTile.id then updateAttributes updatedTile, tile



  addAnimal: (animal) ->
    @penDom.append createAnimalDom animal


  updateLivable: (livable) ->
    _ @tiles
      .flatten()
      .map (tile) -> if tile.crop.id = livable.id then updateAttributes livable, tile.crop
      .value()


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


createAnimalDom = (animal) ->
  animalDom = $ "<div class='animal #{animal.type}' id='#{animal.id}'>#{animal.type}</div>"


updateAttributes = (updatedObject, oldObject) ->
  _.map updatedObject, (value, key) ->
    oldObject[key] = value
