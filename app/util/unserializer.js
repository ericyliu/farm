let ModelClassMap = require('util/model-class-map.js');
let _ = require('lodash');

class Unserializer {

  isArray(value) {
    return value instanceof Array;
  }


  isNormalObject(value) {
    return !value['_className'] && value instanceof Object;
  }


  unserialize(jsonData) {
    // might not want this...
    if (jsonData == null) { return jsonData; }

    if (jsonData['_className']) {
      let klass = ModelClassMap[jsonData['_className']];
      let instance = new klass();
      _.forOwn(jsonData, (value, key) => {
        return instance[key] = this.unserialize(value);
      }
      );
      return instance;
    }
    if (this.isArray(jsonData)) {
      return _.map(jsonData, data => this.unserialize(data));
    }
    if (this.isNormalObject(jsonData)) {
      return _.mapValues(jsonData, data => this.unserialize(data));
    }
    return jsonData;
  }
}


module.exports = Unserializer;
