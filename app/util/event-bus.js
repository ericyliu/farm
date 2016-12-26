let _ = require('lodash');
let Serializer = require('util/serializer.js');

module.exports = {

  registeredEvents: {},
  shouldDebug: false,


  register(event, callback, context) {
    this.log(`Registering callback: ${callback} under event ${event}`);
    if (this.registeredEvents[event] == null) { this.registeredEvents[event] = []; }
    return this.registeredEvents[event].push(_.bind(callback, context));
  },


  registerMany(listeners, context) {
    return _.map(listeners, (callback, event) => this.register(event, callback, context));
  },


  trigger(event, data, shouldStripSubModels) {
    this.log(`Triggering event: ${event}`);
    if (data != null) { this.log(data); }
    let serializedData = (data != null) ? Serializer.serialize(data, shouldStripSubModels) : null;
    if (this.registeredEvents[event] == null) {
      console.info(`Triggering event that has no registered callbacks: ${event}`);
    }
    // debugger
    return _.map(this.registeredEvents[event], function(callback) {
      if (serializedData != null) { return callback((JSON.parse(serializedData))); } else { return callback(); }
    });
  },


  clearListeners() {
    return this.registeredEvents = {};
  },


  debug(shouldDebug) {
    return this.shouldDebug = shouldDebug;
  },


  log(message) {
    if (this.shouldDebug) { return console.log(message); }
  }
};
