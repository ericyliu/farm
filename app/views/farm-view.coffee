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
    'model/Farm/animalRemoved': @removeAnimal
    'model/Farm/expanded': @updateField
    'model/Tile/attributesUpdated': @updateTile
    'model/Crop/attributesUpdated': @updateLivable
    'model/Animal/attributesUpdated': @updateLivable
    'model/Farm/cropAdded': @addCrop


  updateField: (tiles) ->
    @fieldDom.html _.map tiles, createFieldRowDom


  updatePen: (animals) ->
    @penDom.html _.map animals, createAnimalDom


  updateTile: (updatedTile) ->
    newTiles = _.map @tiles, (tileRow) ->
      _.map tileRow, (tile) ->
        if tile.id == updatedTile.id then updatedTile else tile

    @tiles = newTiles


  addAnimal: (animal) ->
    @penDom.append createAnimalDom animal


  removeAnimal: (animal) ->
    @penDom.find(".animal ##{animal.id}").remove()


  updateLivable: (livable) ->
    _ @tiles
      .flatten()
      .map (tile) -> if tile.crop.id = livable.id then tile.crop = livable
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
