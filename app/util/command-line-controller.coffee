class CommandLineController

  constructor: ->
    @gameController = @getGameController()


  getGameController: ->
    window.Farm.gameController


  save: ->
    @gameController.saveGame()


  load: ->
    @gameController.loadGame()


  pause: ->
    @gameController.togglePause()

module.exports = CommandLineController
