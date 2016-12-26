let _ = require('lodash');
let Serializer = require('util/serializer.js');

let registeredEvents = {};
let shouldDebug = false;
let globalListener = null;

module.exports = {

  register(event, callback, context) {
    this.log(`Registering callback: ${callback} under event ${event}`);
    if (registeredEvents[event] == null) { registeredEvents[event] = []; }
    return registeredEvents[event].push(_.bind(callback, context));
  },


  registerMany(listeners, context) {
    return _.map(listeners, (callback, event) => this.register(event, callback, context));
  },


  trigger(event, data, shouldStripSubModels) {
    this.log(`Triggering event: ${event}`);
    if (globalListener) {
      globalListener(event, data);
    }
    if (data != null) { this.log(data); }
    let serializedData = (data != null) ? Serializer.serialize(data, shouldStripSubModels) : null;
    if (registeredEvents[event] == null) {
      this.log(`Triggering event that has no registered callbacks: ${event}`);
    }
    // debugger
    return _.map(registeredEvents[event], function(callback) {
      if (serializedData != null) { return callback((JSON.parse(serializedData))); } else { return callback(); }
    });
  },


  /**
   * Really only used for testing. will give all information about an event
   */
  setGlobalListener(globalListenerArg) {
    globalListener = globalListenerArg;
  },

  clearRegisteredEvents() {
    registeredEvents = {};
  },

  clearListeners() {
    return registeredEvents = {};
  },


  debug(shouldDebugArg) {
    return shouldDebug = shouldDebugArg;
  },


  log(message) {
    if (shouldDebug) { return console.log(message); }
  }
};
