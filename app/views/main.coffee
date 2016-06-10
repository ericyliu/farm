EventBus = require 'util/event-bus.coffee'
$ = require 'jquery'

views = [
  require 'views/hud-view.coffee'
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
  require 'views/tile-menu-view.coffee'
  require 'views/market-view.coffee'
  require 'views/day-end-view.coffee'
]

module.exports =

  start: ->
    EventBus.registerMany @listeners(), @
    _.map views, (view) => view.start()
    @tryConnectionInterval = setInterval (->
      EventBus.trigger 'controller/Game/onViewConnect'
    ), 1000


  listeners: ->
    'controller/Game/onViewConnected': @onConnected
    'controller/Game/gameLoaded': @loadGame


  loadGame: (game) ->
    _.map views, (view) => view.load game


  onConnected: (data) ->
    clearInterval @tryConnectionInterval
    @loadGame data
