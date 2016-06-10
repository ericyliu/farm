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
    EventBus.register 'controller/Game/onViewConnected', @onConnected, @
    @tryConnectionInterval = setInterval (->
      EventBus.trigger 'controller/Game/onViewConnect'
    ), 1000
    EventBus.register 'game/load', @onLoad, @
    @initialHtml = $('body').html()
    @initialHtml = @initialHtml.replace '<script', '<poopiepoop'


  onLoad: (data) ->
    $('body').html @initialHtml
    # todo. i think this will have to clear events on the event bus
    # once the view is on a separate machine (ie unity)
    # right now its being cleared by the game controller and i dont
    # want to clear the event bus twice

    #need the set timeout here because we need to wait for gameController
    # to finish clearing the event bus before reattaching our listeners
    # wont be a problem if the two event busses are separate
    setTimeout (() => @start()), 0


  onConnected: (data) ->
    clearInterval @tryConnectionInterval
    _.map views, (view) => view.start data, @
