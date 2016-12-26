let _ = require('lodash');

let Serializer = {

  /*
  Serializes an object to sent to the ui. This serializes everything except
  child model classes
  */
  serialize(object, shouldStripSubModels) {
    if (!shouldStripSubModels) { return JSON.stringify(object); }
    let objectToSerialize = _.pickBy(object, function(value, key) {
      let isObjectModel = objectIsModel(value);
      if (value instanceof Object) {
        let reducer = (isModel, subValue) => isModel || objectIsModel(subValue);
        isObjectModel = isObjectModel || _.reduce(value, reducer, false);
      }
      return !isObjectModel;
    });
    validateThereAreNoModels(objectToSerialize);
    return JSON.stringify(objectToSerialize);
  }
};



var objectIsModel = object => (object != null) && (object['_className'] != null);

var validateThereAreNoModels = function(object) {
  let flattened = _.flatMapDeep(object);
  return _.map(flattened, function(x) {
    if (objectIsModel(x)) {
      throw "Serializing a sub model";
      return console.log(object);
    }
  });
};

module.exports = Serializer;
