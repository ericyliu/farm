_ = require 'lodash'

module.exports =

  registeredEvents: {}
  shouldDebug: false


  register: (event, callback, context) ->
    @log "Registering callback: #{callback} under event #{event}"
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