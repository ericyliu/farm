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

Unserializer = require 'models/unserializer.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'
Livable = require 'models/livable.coffee'

l = new Livable 'goat', {'grass': 1}, [], {'child': 3}
l.giveFood {'grass': 4}
l.handleDay()
o = (new Unserializer()).unserialize JSON.parse JSON.stringify l

console.log o
console.log o.getCurrentState()
console.log 'hi'
