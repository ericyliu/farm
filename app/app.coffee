_ = require 'lodash'

FPS = 60
GameController = require 'controllers/game-controller.coffee'

views = [
  require 'views/hud-view.coffee'
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
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
