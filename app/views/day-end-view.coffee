$ = require 'jquery'
_ = require 'lodash'
EventBus = require 'util/event-bus.coffee'

module.exports =

  start: ->
    EventBus.registerMany @listeners(), @


  listeners: ->
    'controller/Game/dayEnded': @endDay


  load: (game) ->
    @time = game.timeElapsed


  endDay: (minutes) ->
    $('#DayEnd .previous-day').css 'opacity', '0'
    setTimeout (-> $('#DayEnd .next-day').css 'opacity', '1'), 2000
    setTimeout (=>
      @reset()
      EventBus.trigger 'controller/Game/unpause'
    ), 4000


  reset: ->
    $('#DayEnd').hide()
    $('#DayEnd .previous-day').css 'opacity', '1'
    $('#DayEnd .next-day').css 'opacity', '0'


getDay = (minutes) ->
  Math.floor(Math.floor(minutes / 60) / 24) + 1
