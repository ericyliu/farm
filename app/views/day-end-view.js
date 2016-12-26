let $ = require('jquery');
let _ = require('lodash');
let EventBus = require('util/event-bus.js');

module.exports = {

  start() {
    return EventBus.registerMany(this.listeners(), this);
  },


  listeners() {
    return {'controller/Game/dayEnded': this.endDay};
  },


  load(game) {
    return this.time = game.timeElapsed;
  },


  endDay(minutes) {
    $('#DayEnd .previous-day').css('opacity', '0');
    setTimeout((() => $('#DayEnd .next-day').css('opacity', '1')), 2000);
    return setTimeout((() => {
      this.reset();
      return EventBus.trigger('controller/Game/unpause');
    }
    ), 4000);
  },


  reset() {
    $('#DayEnd').hide();
    $('#DayEnd .previous-day').css('opacity', '1');
    return $('#DayEnd .next-day').css('opacity', '0');
  }
};


let getDay = minutes => Math.floor(Math.floor(minutes / 60) / 24) + 1;
