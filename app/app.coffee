_ = require 'lodash'

window.peek = (thing) ->
  console.log thing
  thing

# Initialize Game
GameController = require 'controllers/game-controller.coffee'
gameController = new GameController()
updateGame = -> gameController.update()
window.Farm.gameUpdateLoop = setInterval updateGame, 1000


# Initialize View
window.FarmEventService = require 'services/event-bus.coffee'
require('views/view.coffee').start()


# Initialize Dev Tools
CommandLineController = require 'util/command-line-controller.coffee'
window.f = new CommandLineController()
