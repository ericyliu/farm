_ = require 'lodash'

class EventBus

  constructor: ->
    @registeredEvents = {}
    @shouldDebug = false
    @events =
      SAVE: 'save'
      LOAD: 'load'


  registerCallback: (event, callback, context) ->
    @log "Registering callback: #{callback}"
    @registeredEvents[event] = [] unless @registeredEvents.event?
    @registeredEvents[event].push _.bind callback, context


  trigger: (event, data) ->
    @log "Triggering event: #{event}"
    @log data if data?
    unless @registeredEvents[event]?
      console.info "Triggering event that has no registered callbacks: #{event}"
    _.map @registeredEvents[event], (callback) ->
      callback data


  debug: (shouldDebug) ->
    @shouldDebug = shouldDebug


  log: (message) ->
    console.log message if @shouldDebug

eventBus = new EventBus()
module.exports = eventBus
