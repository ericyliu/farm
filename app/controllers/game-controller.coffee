DataService = require 'services/data-service.coffee'
FarmController = require 'controllers/farm-controller.coffee'
Game = require 'models/game.coffee'
Tile = require 'models/tile.coffee'
Unserializer = require 'util/unserializer.coffee'

class GameController

  constructor: ->
    @game = new Game()
    @farmController = new FarmController @
    givePlayerStartingItems @game.player


  update: ->
    return if @paused
    @game.timeElapsed += 1
    @farmController.update()
    if isEndOfDay @game
      @farmController.handleLivableDays @farmController.getAllLivables()


  getFarm: ->
    @game.player.farm

  togglePause: (pause) ->
    return @paused = pause if pause isnt undefined
    @paused = not @paused


  saveGame: ->
    localStorage.setItem 'game-save', JSON.stringify @game


  loadGame: ->
    savedState = JSON.parse localStorage.getItem "game-save"
    @game = (new Unserializer()).unserialize savedState


module.exports = GameController


createStartingFarm = ->
  _.map _.range(3), ->
    _.map _.range(3), ->
      new Tile()


givePlayerStartingItems = (player) ->
  player.farm.animals = [DataService.createAnimal 'goat']
  player.farm.tiles = createStartingFarm()
  player.items = [
    DataService.createItem 'grassSeed', 3
    DataService.createItem 'goatManure', 3
  ]

isEndOfDay = (game) ->
  return game.timeElapsed != 0 and game.timeElapsed % (60 * 24) == 0
