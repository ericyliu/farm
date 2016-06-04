$ = require 'jquery'
TileMenuView = require 'views/tile-menu-view.coffee'

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


module.exports =

  update: ->
    @updateField()
    @updatePen()


  updateField: ->
    field = window.Farm?.gameController.game.player.farm.tiles
    return if _.isEqual @previousField, JSON.stringify field
    $('#Farm .field').html _.map field, getRowDom
    @previousField = JSON.stringify field


  updatePen: ->
    pen = window.Farm?.gameController.game.player.farm.animals
    return if _.isEqual @previousPen, JSON.stringify pen
    $('#Farm .pen').html _.map pen, getAnimalDom
    @previousPen = JSON.stringify pen
