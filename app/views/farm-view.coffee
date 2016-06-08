$ = require 'jquery'
EventBus = require 'util/event-bus.coffee'
TileMenuView = require 'views/tile-menu-view.coffee'

module.exports =

  start: (game) ->
    @fieldDom = $ '#Farm .field'
    @penDom = $ '#Farm .pen'
    @updateField game.player.farm.tiles
    @updatePen game.player.farm.animals
    EventBus.registerMany @listeners(), @


  listeners: ->
    'farm/fieldUpdated': @updateField
    'farm/animalAdded': @addAnimal
    'farm/animalRemoved': @removeAnimal
    'tile/attributesUpdated': @updateTile
    'crop/attributesUpdated': @updateCrop
    'animal/attributesUpdated': @updateAnimal


  updateField: (tiles) ->
    @fieldDom.html _.map tiles, createFieldRowDom


  updatePen: (animals) ->
    @penDom.html _.map animals, createAnimalDom


  updateTile: (tile) ->
    @fieldDom.find(".tile##{tile.id}").replaceWith createTileDom tile


  updateCrop: (crop) ->
    @fieldDom.find(".crop##{crop.id}").replaceWith createCropDom tile


  addAnimal: (animal) ->
    @penDom.append createAnimalDom animal


  removeAnimal: (animal) ->
    @penDom.find(".animal##{animal.id}").remove()


  updateAnimal: (animal) ->
    @penDom.find(".animal##{animal.id}").replaceWith createAnimalDom animal


createFieldRowDom = (row) ->
  $("<div class='row'></div>").append _.map row, createTileDom

createTileDom = (tile) ->
  tileDom = $ "<div class='tile' id='#{tile.id}'>"
  tileDom.append createCropDom tile.crop if tile.crop?
  tileDom

createCropDom = (crop) ->
  cropClass = "crop #{crop.type} life-stage-#{crop.lifeStage}"
  $ "<div class='#{cropClass}' id='#{crop.id}'></div>"


createAnimalDom = (animal) ->
  animalDom = $ "<div class='animal #{animal.type}' id='#{animal.id}'></div>"
