let chai = require('chai');
let sinon = require('sinon');
let EventBus = require('util/event-bus')
chai.use(require('sinon-chai'));

global.chai = chai;
global.expect = chai.expect;
global.assert = chai.assert;
global.sinon = sinon;

global.eventBus = EventBus


process.env.NODE_ENV = 'test';
