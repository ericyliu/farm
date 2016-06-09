_ = require 'lodash'
Serializer = require 'util/serializer.coffee'

module.exports =

  registeredEvents: {}
  shouldDebug: false


  register: (event, callback, context) ->
    @log "Registering callback: #{callback} under event #{event}"
    @registeredEvents[event] = [] unless @registeredEvents[event]?
    @registeredEvents[event].push _.bind callback, context


  registerMany: (listeners, context) ->
    _.map listeners, (callback, event) => @register event, callback, context


  trigger: (event, data, shouldStripSubModels) ->
    @log "Triggering event: #{event}"
    @log data if data?
    serializedData = if data? then Serializer.serialize(data, shouldStripSubModels) else null
    unless @registeredEvents[event]?
      console.info "Triggering event that has no registered callbacks: #{event}"
    # debugger
    _.map @registeredEvents[event], (callback) ->
      if serializedData? then callback (JSON.parse serializedData) else callback()



  debug: (shouldDebug) ->
    @shouldDebug = shouldDebug


  log: (message) ->
    console.log message if @shouldDebug
