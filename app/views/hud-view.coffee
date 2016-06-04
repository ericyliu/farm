$ = require 'jquery'
_ = require 'lodash'
TimeService = require 'services/time-service.coffee'

playbackButtons = []

setPlaybackInfoDom = (playing, speed) ->
  $('#Hud .right .playback-info').html $ """
    <div class='play-status'>#{if playing then 'Playing' else 'Paused'}</div>
    <div class='speed'>x#{speed}</div>
  """

getButtonDoms = ->
  _.map playbackButtons, (button) ->
    $ "<div class='btn'>#{button.label}</div>"
      .on 'click', -> button.method()

getTimeDom = ->
  $ "<div class='time'>Time: #{TimeService.getHumanTime window.Farm.gameController.game.timeElapsed}</div>"

getMoneyDom = ->
  $ "<div class='money'>Gold: #{window.Farm.gameController.game.player.money}</div>"


module.exports =

  playSpeed: 1

  setup: ->
    playbackButtons = [
        label: '||'
        method: =>
          window.Farm.gameController.togglePause true
          setPlaybackInfoDom false, @playSpeed
      ,
        label: '>'
        method: =>
          window.Farm.gameController.togglePause false
          f.normalSpeed()
          setPlaybackInfoDom true, 1
          @playSpeed = 1
      ,
        label: '>>'
        method: =>
          window.Farm.gameController.togglePause false
          @playSpeed *= 2
          f.fastForward @playSpeed
          setPlaybackInfoDom true, @playSpeed
    ]
    setPlaybackInfoDom true, 1
    $('#Hud .right').append getButtonDoms()


  update: ->
    $('#Hud .time').html [getTimeDom(), getMoneyDom()]
