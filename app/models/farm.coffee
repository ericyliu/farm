Base = require 'models/base.coffee'
Tile = require 'models/tile.coffee'
EventBus = require 'util/event-bus.coffee'


class Farm extends Base

  constructor: (options) ->
    super(options)


  spec: ->
    _className: 'Farm'

    animals: []
    tiles: []
    #private


  expand: ->
    newRow = _.map _.range(_.size(@tiles[0]) + 1), -> new Tile
    @tiles = _ @tiles
      .map (row) -> _.concat row, new Tile
      .concat [newRow]
      .value()
    EventBus.trigger 'model/Farm/expanded', @tiles


module.exports = Farm
