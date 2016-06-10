class PlayerController

  constructor: (@gameController) ->


  getPlayer: ->
    @gameController.game.player


  registerListeners: () ->
    # needed by code that handles loading


module.exports = PlayerController
