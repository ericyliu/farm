let updateGame = () => window.Farm.gameController.update();


class CommandLineController {

  constructor() {
    this.gameController = this.getGameController();
  }


  getGameController() {
    return window.Farm.gameController;
  }


  listEventBusEvents() {
    return _.keys(require('util/event-bus.js').registeredEvents);
  }


  save() {
    return this.gameController.saveGame();
  }


  load() {
    return this.gameController.loadGame();
  }


  pause() {
    return this.gameController.togglePause();
  }


  fastForward(multiple) {
    clearInterval(window.Farm.gameUpdateLoop);
    return window.Farm.gameUpdateLoop = setInterval(updateGame, (1000 / multiple));
  }


  normalSpeed() {
    return this.fastForward(1);
  }
}

module.exports = CommandLineController;
