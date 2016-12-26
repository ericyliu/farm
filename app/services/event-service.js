let _ = require('lodash');

/*
As opposed to the event bus, the event service only handles backend events
*/

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


  trigger(event, data) {
    this.log(`Triggering event: ${event}`);
    if (data != null) { this.log(data); }
    if (this.registeredEvents[event] == null) {
      console.info(`Triggering event that has no registered callbacks: ${event}`);
    }
    return _.map(this.registeredEvents[event], callback => callback(data));
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
