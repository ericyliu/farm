let _ = require('lodash');

window.peek = function(thing) {
  console.log(thing);
  return thing;
};

// Initialize View
require('views/main.js').start();


// Initialize Game
let GameController = require('controllers/game-controller.js');
window.Farm = {gameController: new GameController()};
let updateGame = () => window.Farm.gameController.update();
window.Farm.gameUpdateLoop = setInterval(updateGame, 1000);


// Initialize Dev Tools
let CommandLineController = require('util/command-line-controller.js');
window.f = new CommandLineController();
