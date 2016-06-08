updateGame = ->
  window.Farm.gameController.update()


class CommandLineController

  constructor: ->
    @gameController = @getGameController()


  getGameController: ->
    window.Farm.gameController


  listEventBusEvents: ->
    _.keys require('util/event-bus.coffee').registeredEvents


  save: ->
    @gameController.saveGame()


  load: ->
    @gameController.loadGame()


  pause: ->
    @gameController.togglePause()


  fastForward: (multiple) ->
    clearInterval window.Farm.gameUpdateLoop
    window.Farm.gameUpdateLoop = setInterval updateGame, (1000 / multiple)


  normalSpeed: () ->
    @fastForward 1

module.exports = CommandLineController
