IdService = require 'services/id-service.coffee'
EventBus = require 'util/event-bus.coffee'
_ = require 'lodash'

class ModelBase
  constructor: (options) ->
    @id = IdService.get()
    _.map @spec(), (value, key) => @[key] = value
    _.map options, (value, key) => @[key] = value if value?


  set: (key, value) ->
    console.error "#{key} not in spec" unless _.includes _.keys(@spec()), key
    @[key] = value
    if not @_className?
      throw "model does not have _className defined"
    EventBus.trigger("model/#{@_className}/attributesUpdated", @)


  spec: () ->
    throw "getModelAttributeKeys should be overriden by the subclass"

module.exports = ModelBase
