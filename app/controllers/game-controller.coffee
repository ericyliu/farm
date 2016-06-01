DataController = require 'controllers/data-controller.coffee'
Game = require 'models/game.coffee'
Item = require 'models/item.coffee'
Tile = require 'models/tile.coffee'

createStartingFarm = ->
  _.map _.range(3), ->
    _.map _.range(3), ->
      new Tile()

givePlayerStartingItems = (player) ->
  player.farm.animals = [DataController.createAnimal 'goat']
  player.farm.tiles = createStartingFarm()
  player.items = [new Item 3, 'grassSeeds']


class GameController

  constructor: ->
    @game = new Game()
    givePlayerStartingItems @game.player


  update: ->


module.exports = GameController
