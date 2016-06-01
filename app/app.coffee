_ = require 'lodash'

GameController = require 'controllers/game-controller.coffee'

views = [
  require 'views/inventory-view.coffee'
  require 'views/farm-view.coffee'
]

updateViews = -> _.map views, (view) ->
  return unless window.Farm?.gameController
  view.update()

window.Farm = gameController: new GameController()
window.Farm.viewUpdateLoop = setInterval updateViews, 1000
window.Farm.gameUpdateLoop = setInterval window.Farm.gameController.update, 1000
