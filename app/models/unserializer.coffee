ModelClassMap = require('models/model-class-map.coffee')

class Unserializer

  isPrimitive: (value) ->
    typeof value == 'undefined' or
    typeof value == 'number' or
    typeof value == 'string'

  isArray: (value) ->
    value instanceof Array

  isNormalObject: (value) ->
    !value['_className']

  unserialize: (jsonData) ->
    if @isPrimitive jsonData
      return jsonData
    if jsonData['_className']
      c = ModelClassMap(jsonData['_className'])
      o = new c()
      _.forOwn jsonData, (value, key) =>
        o[key] = @unserialize(value)
        x = 8
      return o
    if @isArray jsonData
      return _.map jsonData, (data) => @unserialize data
    debugger
    return _.mapValues jsonData, (data) => @unserialize data


module.exports = Unserializer
