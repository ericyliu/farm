let IdService = require('services/id-service.js');
let EventBus = require('util/event-bus.js');
let _ = require('lodash');

class ModelBase {
  constructor(options) {
    this.id = IdService.get();
    _.map(this.spec(), (value, key) => this[key] = value);
    _.map(options, (value, key) => { if (value != null) { return this[key] = value; } });
  }


  set(key, value) {
    if (!_.includes(_.keys(this.spec()), key)) { console.error(`${key} not in spec`); }
    this[key] = value;
    if (this._className == null) {
      throw "model does not have _className defined";
    }
    return EventBus.trigger(`model/${this._className}/attributesUpdated`, this, true);
  }


  spec() {
    throw "getModelAttributeKeys should be overriden by the subclass";
  }
}

module.exports = ModelBase;
