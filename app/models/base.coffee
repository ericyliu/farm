IdService = require 'services/id-service.coffee'
EventBus = require 'services/event-bus.coffee'
_ = require 'lodash'

class ModelBase
  constructor: (options) ->
    @id = IdService.get()
    _.map @spec(), (value, key) => @set key, value
    _.map options, (value, key) => @set key, value if value?


  set: (key, value) ->
    @[key] = value
    if not @_className?
      throw "model does not have _className defined"
    EventBus.trigger("model/#{@_className}/#{@id}", @)


  spec: () ->
    throw "getModelAttributeKeys should be overriden by the subclass"

module.exports = ModelBase
