$ = require 'jquery'

module.exports =

  setup: ->
    $('#Hud .pause').on 'click', ->
      window.Farm.gameController.togglePause()


  update: ->
    gameController = @getGameController()
    $('#Hud .time').html "Time: #{@getHumanTime()}"
    $('#Hud .pause').html "#{if gameController.paused then 'Unpause' else 'Pause'}"


  getHumanTime: ->
    gameController = @getGameController()
    minute = Math.floor(gameController.game.timeElapsed % 60)
    hour = Math.floor(gameController.game.timeElapsed / 60) % 24
    day = Math.floor(Math.floor(gameController.game.timeElapsed / 60) / 24) + 1

    minuteString = "#{minute}"
    minuteString = "0#{minute}" if minute < 10
    "Day #{day} - #{hour}:#{minuteString}"


  getGameController: ->
    window.Farm.gameController
