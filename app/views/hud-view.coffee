$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: (game) ->
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
      ,
        label: 'Market'
        method: => $('#Market').show()
      ,
        label: 'End Day'
        method: => @endDay()
      ,
        label: 'Load'
        method: => f.load()
      ,
        label: 'Save'
        method: => f.save()
    ]
    @playSpeed = 1
    setPlaybackInfoDom true, 1
    $('#Hud .right').append createButtonDoms playbackButtons
    @updateAttributes game
    EventBus.registerMany @listeners(), @


  listeners: ->
    'model/Game/attributesUpdated': @updateTime
    'model/Player/attributesUpdated': @updateMoney


  endDay: ->
    $('#DayEnd').show()
    $('#DayEnd .previous-day').html "Day - #{@day}, End"
    $('#DayEnd .next-day').html "Day - #{@day + 1}, Start"
    setTimeout -> EventBus.trigger 'controller/Game/endDay'


  updateAttributes: (game) ->
    $('#Hud .left').html [
      createTimeDom game.timeElapsed
      createMoneyDom game.player.money
    ]


  updateTime: (game) ->
    @day = Math.floor(Math.floor(game.timeElapsed / 60) / 24) + 1
    $('#Hud .left .time').html "Time: #{formatTime game.timeElapsed}"


  updateMoney: (player) ->
     $('#Hud .left .money').html "Gold: #{player.money}"



setPlaybackInfoDom = (playing, speed) ->
  $('#Hud .right .playback-info').html $ """
    <div class='play-status'>#{if playing then 'Playing' else 'Paused'}</div>
    <div class='speed'>x#{speed}</div>
  """

createButtonDoms = (playbackButtons) ->
  _.map playbackButtons, (button) ->
    $ "<div class='btn'>#{button.label}</div>"
      .on 'click', -> button.method()

createTimeDom = (time) ->
  $ "<div class='time'>Time: #{formatTime time}</div>"

createMoneyDom = (money) ->
  $ "<div class='money'>Gold: #{money}</div>"

formatTime = (minutes) ->
    minute = Math.floor minutes % 60
    hour = Math.floor(minutes / 60) % 24
    ampm = if hour < 12 then 'am' else 'pm'
    hour = hour - 12 if hour >= 12
    hour = 12 if hour is 0
    day = Math.floor(Math.floor(minutes / 60) / 24) + 1

    minuteString = "#{minute}"
    minuteString = "0#{minute}" if minute < 10
    "Day #{day} - #{hour}:#{minuteString} #{ampm}"
