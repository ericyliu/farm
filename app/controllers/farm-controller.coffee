DataService = require 'services/data-service.coffee'


class FarmController

  constructor: (@gameController) ->


  plant: (tile, item) ->
    tile.crop = DataService.itemToCrop item
    @gameController.game.player.removeItem item


module.exports = FarmController
