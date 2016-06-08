_ = require 'lodash'

window.peek = (thing) ->
  console.log thing
  thing

# Initialize Game
GameController = require 'controllers/game-controller.coffee'
window.Farm = gameController: new GameController()
updateGame = -> window.Farm.gameController.update()
window.Farm.gameUpdateLoop = setInterval updateGame, 1000


# Initialize View
require('views/main.coffee').start()


# Initialize Dev Tools
CommandLineController = require 'util/command-line-controller.coffee'
window.f = new CommandLineController()
