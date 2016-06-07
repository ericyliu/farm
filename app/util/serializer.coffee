_ = require 'lodash'

class Serializer

  ###
  Serializes an object to sent to the ui. This serializes everything except
  child model classes
  ###
  serialize: (object) ->
    objectToSerialize = _.pick object, (value, key) ->
      isModel = objectIsModel object
      isModelCollection = _.reduce value, (isModel, subValue) -> isModel or objectIsModel subValue, false
      not (isModel or isModelCollection)
    validateThereAreNoModels object
    JSON.stringify objectToSerialize



objectIsModel = (object) -> object['_className']?

validateThereAreNoModels = (object) ->
  flattened = _.flatMapDeep object
  _.map flattened (x) ->
    if objectIsModel x
      throw "Serializing a sub model"
      console.log object
