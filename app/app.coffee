_ = require 'lodash'

window.peek = (thing) ->
  console.log thing
  thing

FPS = 60
GameController = require 'controllers/game-controller.coffee'
CommandLineController = require 'util/command-line-controller.coffee'

views = [
  require 'views/hud-view.coffee'
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
  require 'views/tile-menu-view.coffee'
]

updateViews = -> _.map views, (view) ->
  return unless window.Farm?.gameController
  view.update?()

updateGame = ->
  window.Farm.gameController.update()

window.Farm = gameController: new GameController()
_.map views, (view) -> view.setup?()
window.Farm.viewUpdateLoop = setInterval updateViews, 1000 / FPS
window.Farm.gameUpdateLoop = setInterval updateGame, 1000

window.f = new CommandLineController()

TestRunner = require 'tests/test-runner.coffee'
