ModelClassMap = require('util/model-class-map.coffee')

class Unserializer

  isArray: (value) ->
    value instanceof Array


  isNormalObject: (value) ->
    !value['_className'] and value instanceof Object


  unserialize: (jsonData) ->
    if jsonData['_className']
      klass = ModelClassMap[jsonData['_className']]
      instance = new klass()
      _.forOwn jsonData, (value, key) =>
        instance[key] = @unserialize(value)
        x = 8
      return instance
    if @isArray jsonData
      return _.map jsonData, (data) => @unserialize data
    if @isNormalObject jsonData
      return _.mapValues jsonData, (data) => @unserialize data
    return jsonData


module.exports = Unserializer
