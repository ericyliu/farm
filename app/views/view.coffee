views = [
  require 'views/hud-view.coffee'
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
  require 'views/tile-menu-view.coffee'
]

module.exports =

  start: ->
    window.FarmEventService.register 'game/onViewConnected', @onConnected, @
    @tryConnectionInterval = setInterval (->
      window.FarmEventService.trigger 'game/onViewConnect'
    ), 1000


  onConnected: (data) ->
    clearInterval @tryConnectionInterval
    # game = JSON.parse data
    _.map views, (view) => view.start? data, @


  registerListeners: (listeners, context) ->
    _.map listeners, (fn, event) ->
      window.FarmEventService.register event, fn, context
