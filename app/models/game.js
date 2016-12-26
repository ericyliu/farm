let _ = require('lodash');
let Base = require('models/base.js');
let Player = require('models/player.js');
let Farm = require('models/farm.js');
let Market = require('models/market.js');
let EventBus = require('util/event-bus.js');

class Game extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Game',

      name: 'Player 1',
      //private
      player: new Player({name: 'Player 1', farm: new Farm()}),
      timeElapsed: 7 * 60,
      market: new Market()
    };
  }
}


module.exports = Game;
