_ = require 'lodash'

Serializer =

  ###
  Serializes an object to sent to the ui. This serializes everything except
  child model classes
  ###
  serialize: (object, shouldStripSubModels) ->
    if not shouldStripSubModels then return JSON.stringify object
    objectToSerialize = _.pickBy object, (value, key) ->
      isObjectModel = objectIsModel value
      if value instanceof Object
        reducer = (isModel, subValue) -> isModel or objectIsModel(subValue)
        isObjectModel = isObjectModel or _.reduce(value, reducer, false)
      not isObjectModel
    validateThereAreNoModels objectToSerialize
    JSON.stringify objectToSerialize



objectIsModel = (object) -> object? and object['_className']?

validateThereAreNoModels = (object) ->
  flattened = _.flatMapDeep object
  _.map flattened, (x) ->
    if objectIsModel x
      throw "Serializing a sub model"
      console.log object

module.exports = Serializer
