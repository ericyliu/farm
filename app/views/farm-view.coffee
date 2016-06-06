$ = require 'jquery'
TileMenuView = require 'views/tile-menu-view.coffee'
eventBus = require 'services/event-bus.coffee'

FarmView =
  update: ->
    @updateField()
    @updatePen()


  reset: ->
    @previousState = {}


  updateField: ->
    @previousState = {} if not @previousState?
    field = getGameController().game.player.farm.tiles
    return if _.isEqual @previousState.field, JSON.stringify field
    $('#Farm .field').html _.map field, getRowDom
    @previousState.field = JSON.stringify field


  updatePen: ->
    @previousState = {} if not @previousState?
    pen = getGameController().game.player.farm.animals
    return if _.isEqual @previousState.pen, JSON.stringify pen
    $('#Farm .pen').html _.map pen, getAnimalDom
    @previousState.pen = JSON.stringify pen


getGameController = ->
  window.Farm?.gameController


getRowDom = (row) ->
  $("<div class='row'></div>").append _.map row, getTileDom


getTileDom = (tile) ->
  tileDom = $ """
    <div class='tile'>
      <div class='crop crop-#{tile.crop?.type or ''} life-stage-#{tile.crop?.getCurrentLifeStage()}'></div>
    </div>
  """
  tileDom.on 'click', (evt) -> TileMenuView.openTileMenu evt, tile


getAnimalDom = (animal) ->
  animalDom = $ "<div class='animal'>#{animal.type}</div>"
  animalTrough = getGameController().farmController.animalTrough
  animalDom.on 'click', (evt) -> TileMenuView.openTileMenu evt, animalTrough


eventBus.registerCallback eventBus.events.LOAD, FarmView.reset, FarmView

module.exports = FarmView
