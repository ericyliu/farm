EventBus = require 'util/event-bus.coffee'

views = [
  require 'views/hud-view.coffee'
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
  require 'views/tile-menu-view.coffee'
  require 'views/market-view.coffee'
]

module.exports =

  start: ->
    EventBus.register 'game/onViewConnected', @onConnected, @
    @tryConnectionInterval = setInterval (->
      EventBus.trigger 'game/onViewConnect'
    ), 1000


  onConnected: (data) ->
    clearInterval @tryConnectionInterval
    _.map views, (view) => view.start? data, @
