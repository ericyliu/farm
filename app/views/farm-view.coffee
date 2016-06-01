$ = require 'jquery'

getRowDom = (row) ->
  tileDoms = _.chain row
    .map getTileDom
    .join ''
    .value()
  "<div class='row'>#{_.join tileDoms, ''}</div>"

getTileDom = (tile) ->
  "<div class='tile'>#{tile.livable?.type or ''}</div>"

getAnimalDom = (animal) ->
  "<div class='animal'>#{animal.type}</div>"

module.exports =

  update: ->
    @updateField()
    @updatePen()

  updateField: ->
    field = window.Farm?.gameController.game.player.farm.tiles
    return if field is @previousField
    fieldView = $ '#Farm .field'
    rowDoms = _.map field, getRowDom
    fieldView.html _.join rowDoms, ''
    @previousField = field

  updatePen: ->
    pen = window.Farm?.gameController.game.player.farm.animals
    return if pen is @previousPen
    penView = $ '#Farm .pen'
    animalDoms = _.map pen, getAnimalDom
    penView.html _.join animalDoms, ''
    @previousPen = pen
