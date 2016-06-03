DataService = require 'services/data-service.coffee'
FarmController = require 'controllers/farm-controller.coffee'
Game = require 'models/game.coffee'
Item = require 'models/item.coffee'
Tile = require 'models/tile.coffee'

createStartingFarm = ->
  _.map _.range(3), ->
    _.map _.range(3), ->
      new Tile()

givePlayerStartingItems = (player) ->
  player.farm.animals = [DataService.createAnimal 'goat']
  player.farm.tiles = createStartingFarm()
  player.items = [new Item 'grassSeed', 3]


class GameController

  constructor: ->
    @game = new Game()
    @farmController = new FarmController @, @game.player.farm
    givePlayerStartingItems @game.player


  update: ->
    return if @paused
    @game.timeElapsed += 1 if @game
    @farmController.update()


  togglePause: ->
    @paused = not @paused




module.exports = GameController
