$ = require 'jquery'
TileMenuView = require 'views/tile-menu-view.coffee'
eventBus = require 'services/event-bus.coffee'

getRowDom = (row) ->
  $("<div class='row'></div>").append _.map row, getTileDom

getTileDom = (tile) ->
  tileDom = $ """
    <div class='tile'>
      <div class='crop crop-#{tile.crop?.type or ''} life-stage-#{tile.crop?.getCurrentLifeStage()}'></div>
    </div>
  """
  tileDom.on 'click', (evt) -> TileMenuView.openTileMenu evt, tile
  tileDom

getAnimalDom = (animal) ->
  $ "<div class='animal'>#{animal.type}</div>"


FarmView =
  update: ->
    @updateField()
    @updatePen()


  reset: ->
    @previousState = {}


  updateField: ->
    @previousState = {} if not @previousState?
    field = window.Farm?.gameController.game.player.farm.tiles
    @reset()
    return if _.isEqual @previousState.field, JSON.stringify field
    $('#Farm .field').html _.map field, getRowDom
    @previousState.field = JSON.stringify field


  updatePen: ->
    @previousState = {} if not @previousState?
    pen = window.Farm?.gameController.game.player.farm.animals
    return if _.isEqual @previousState.pen, JSON.stringify pen
    $('#Farm .pen').html _.map pen, getAnimalDom
    @previousState.pen = JSON.stringify pen


eventBus.registerCallback eventBus.events.LOAD, FarmView.reset, FarmView
eventBus.debug(true)

module.exports = FarmView
