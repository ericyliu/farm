$ = require 'jquery'

module.exports =

  setup: ->
    $('#Hud .pause').on 'click', ->
      window.Farm.gameController.togglePause()


  update: ->
    gameController = window.Farm.gameController
    $('#Hud .time').html "Time: #{gameController.game.timeElapsed}"
    $('#Hud .pause').html "#{if gameController.paused then 'Unpause' else 'Pause'}"
