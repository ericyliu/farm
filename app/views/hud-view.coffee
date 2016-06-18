$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: (game) ->
    EventBus.registerMany @listeners(), @
    playbackButtons = [
        label: 'Pause'
        method: =>
          window.Farm.gameController.togglePause true
          setPlaybackInfoDom false, @playSpeed
      ,
        label: 'Play'
        method: =>
          window.Farm.gameController.togglePause false
          f.normalSpeed()
          setPlaybackInfoDom true, 1
          @playSpeed = 1
      ,
        label: 'Fast Forward'
        method: =>
          window.Farm.gameController.togglePause false
          @playSpeed *= 2
          f.fastForward @playSpeed
          setPlaybackInfoDom true, @playSpeed
      ,
        label: 'End Day'
        method: => @endDay()
      ,
        label: 'Save'
        method: => f.save()
      ,
        label: 'Load'
        method: => f.load()
    ]
    setHudButtons()
    $('#Hud .settings .buttons').append createButtonDoms playbackButtons


  listeners: ->
    'model/Game/attributesUpdated': @updateTime
    'model/Player/attributesUpdated': @updateMoney


  load: (game) ->
    @playSpeed = 1
    setPlaybackInfoDom true, 1
    @updateAttributes game


  endDay: ->
    toggleSettings()
    $('#DayEnd').show()
    $('#DayEnd .previous-day').html "Day - #{@day}, End"
    $('#DayEnd .next-day').html "Day - #{@day + 1}, Start"
    setTimeout (-> EventBus.trigger 'controller/Game/endDay'), 100


  updateAttributes: (game) ->
    $('#Hud .status').html [
      createTimeDom game.timeElapsed
      createMoneyDom game.player.money
    ]


  updateTime: (game) ->
    @day = Math.floor(Math.floor(game.timeElapsed / 60) / 24) + 1
    $('#Hud .status .time').html "#{formatTime game.timeElapsed}"


  updateMoney: (player) ->
     $('#Hud .status .money').html "#{player.money}"


setHudButtons = ->
  $('#Hud a.btn.main-btn.settings-icon').click toggleSettings
  $('#Hud .settings a.btn.main-btn.close-icon').click toggleSettings
  $('#Hud a.btn.main-btn.field-icon').click toggleFieldPen
  $('#Hud a.btn.main-btn.pen-icon').click toggleFieldPen
  $('#Hud a.btn.main-btn.inventory-icon').click toggleInventory

toggleSettings = ->
  $('#Hud .settings').toggle()

toggleFieldPen = ->
  $('#Hud a.btn.main-btn.field-icon').toggle()
  $('#Hud a.btn.main-btn.pen-icon').toggle()
  $('#Farm .field').toggle()
  $('#Farm .pen').toggle()

toggleInventory = ->
  $('#Inventory').toggle()



setPlaybackInfoDom = (playing, speed) ->
  $('#Hud .settings .playback-info').html $ """
    <span class='play-status'>#{if playing then 'Playing' else 'Paused'}</span>
    <span class='speed'>x#{speed}</span>
  """

createButtonDoms = (playbackButtons) ->
  _.map playbackButtons, (button) ->
    $ "<div class='btn'>#{button.label}</div>"
      .on 'click', -> button.method()

createTimeDom = (time) ->
  $ "<div class='time'>#{formatTime time}</div>"

createMoneyDom = (money) ->
  $ "<div class='money'><span class='icon'></span>#{money}</div>"

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
