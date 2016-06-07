IdService = require 'services/id-service.coffee'

class ModelBase
  constructor: (options) ->
    @id = IdService.get()
    _.map @spec(), (value, key) => @set key, value
    _.map options, (value, key) => @set key, value if value?


  set: (key, value) ->
    @[key] = value


  spec: () ->
    throw "getModelAttributeKeys should be overriden by the subclass"

module.exports = ModelBase
