let $ = require('jquery');
let _ = require('lodash');
let EventBus = require('util/event-bus.js');

module.exports = {

  start(game) {
    EventBus.registerMany(this.listeners(), this);
    let playbackButtons = [{
        label: 'Pause',
        method: () => {
          window.Farm.gameController.togglePause(true);
          return setPlaybackInfoDom(false, this.playSpeed);
        }
      }
      , {
        label: 'Play',
        method: () => {
          window.Farm.gameController.togglePause(false);
          f.normalSpeed();
          setPlaybackInfoDom(true, 1);
          return this.playSpeed = 1;
        }
      }
      , {
        label: 'Fast Forward',
        method: () => {
          window.Farm.gameController.togglePause(false);
          this.playSpeed *= 2;
          f.fastForward(this.playSpeed);
          return setPlaybackInfoDom(true, this.playSpeed);
        }
      }
      , {
        label: 'End Day',
        method: () => this.endDay()
      }
      , {
        label: 'Save',
        method: () => f.save()
      }
      , {
        label: 'Load',
        method: () => f.load()
      }
    ];
    setHudButtons();
    return $('#Hud .settings .buttons').append(createButtonDoms(playbackButtons));
  },


  listeners() {
    return {
      'model/Game/attributesUpdated': this.updateTime,
      'model/Player/attributesUpdated': this.updateMoney
    };
  },


  load(game) {
    this.playSpeed = 1;
    setPlaybackInfoDom(true, 1);
    return this.updateAttributes(game);
  },


  endDay() {
    toggleSettings();
    $('#DayEnd').show();
    $('#DayEnd .previous-day').html(`Day - ${this.day}, End`);
    $('#DayEnd .next-day').html(`Day - ${this.day + 1}, Start`);
    return setTimeout((() => EventBus.trigger('controller/Game/endDay')), 100);
  },


  updateAttributes(game) {
    return $('#Hud .status').html([
      createTimeDom(game.timeElapsed),
      createMoneyDom(game.player.money)
    ]);
  },


  updateTime(game) {
    this.day = Math.floor(Math.floor(game.timeElapsed / 60) / 24) + 1;
    return $('#Hud .status .time').html(`${formatTime(game.timeElapsed)}`);
  },


  updateMoney(player) {
    return $('#Hud .status .money').html(`<span class='icon'></span>${player.money}`);
  }
};


var setHudButtons = function() {
  $('#Hud .btn.main-btn.settings-icon').click(toggleSettings);
  $('#Hud .settings .btn.main-btn.close-icon').click(toggleSettings);
  $('#Hud .btn.main-btn.field-icon').click(toggleFieldPen);
  $('#Hud .btn.main-btn.pen-icon').click(toggleFieldPen);
  $('#Hud .btn.main-btn.market-icon').click(toggleMarket);
  return $('#Hud .btn.main-btn.inventory-icon').click(toggleInventory);
};

var toggleSettings = () => $('#Hud .settings').toggle();

var toggleFieldPen = function() {
  $('#Hud .btn.main-btn.field-icon').toggle();
  $('#Hud .btn.main-btn.pen-icon').toggle();
  $('#Farm .field').toggle();
  return $('#Farm .pen').toggle();
};

var toggleMarket = () => $('#Market').toggle();

var toggleInventory = () => $('#Inventory').toggle();

var setPlaybackInfoDom = (playing, speed) =>
  $('#Hud .settings .playback-info').html($(`\
<span class='play-status'>${playing ? 'Playing' : 'Paused'}</span>
<span class='speed'>x${speed}</span>\
`
  )
  )
;

var createButtonDoms = playbackButtons =>
  _.map(playbackButtons, button =>
    $(`<div class='btn'>${button.label}</div>`)
      .on('click', () => button.method())
  )
;

var createTimeDom = time => $(`<div class='time'>${formatTime(time)}</div>`);

var createMoneyDom = money => $(`<div class='money'><span class='icon'></span>${money}</div>`);

var formatTime = function(minutes) {
  let minute = Math.floor(minutes % 60);
  let hour = Math.floor(minutes / 60) % 24;
  let ampm = hour < 12 ? 'am' : 'pm';
  if (hour >= 12) { hour = hour - 12; }
  if (hour === 0) { hour = 12; }
  let day = Math.floor(Math.floor(minutes / 60) / 24) + 1;

  let minuteString = `${minute}`;
  if (minute < 10) { minuteString = `0${minute}`; }
  return `Day ${day} - ${hour}:${minuteString} ${ampm}`;
};
