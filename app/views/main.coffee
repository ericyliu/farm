EventBus = require 'util/event-bus.coffee'

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
    EventBus.register 'controller/Game/onViewConnected', @onConnected, @
    @tryConnectionInterval = setInterval (->
      EventBus.trigger 'controller/Game/onViewConnect'
    ), 1000


  onConnected: (data) ->
    clearInterval @tryConnectionInterval
    _.map views, (view) => view.start? data, @
