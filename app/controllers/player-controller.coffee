class PlayerController

  constructor: (@gameController) ->


  getPlayer: ->
    @gameController.game.player


module.exports = PlayerController
