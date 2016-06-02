class CommandLineController

  constructor: ->
    @gameController = @getGameController()


  getGameController: ->
    window.Farm.gameController


  save: ->


  pause: ->
    @gameController.togglePause()

module.exports = CommandLineController
