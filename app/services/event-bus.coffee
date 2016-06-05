_ = require 'lodash'

class EventBus

  constructor: ->
    @registered_events = {}
    @shouldDebug = false
    @events =
      SAVE: 'save'
      LOAD: 'load'


  registerCallback: (event, callback, context) ->
    @log "Registering callback: #{callback}"
    @registered_events[event] = [] if not @registered_events.event?
    @registered_events[event].push _.bind callback, context


  trigger: (event, data) ->
    @log "Triggering event: #{event}"
    @log data if data?
    if not @registered_events[event]?
      console.info "Triggering event that has no registered callbacks: #{event}"
    _.map @registered_events[event], (callback) ->
      callback data


  debug: (shouldDebug) ->
    @shouldDebug = shouldDebug


  log: (message) ->
    console.log message if @shouldDebug

eventBus = new EventBus()
module.exports = eventBus
