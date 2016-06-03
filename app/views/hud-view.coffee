$ = require 'jquery'
TimeService = require 'services/time-service.coffee'

module.exports =

  setup: ->
    $('#Hud .pause').on 'click', ->
      window.Farm.gameController.togglePause()


  update: ->
    gameController = @getGameController()
    $('#Hud .time').html "Time: #{TimeService.getHumanTime window.Farm.gameController.game.timeElapsed}"
    $('#Hud .pause').html "#{if gameController.paused then 'Unpause' else 'Pause'}"


  getGameController: ->
    window.Farm.gameController
