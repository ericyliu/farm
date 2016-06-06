DataService = require 'services/data-service.coffee'
FarmController = require 'controllers/farm-controller.coffee'
PlayerController = require 'controllers/player-controller.coffee'
Game = require 'models/game.coffee'
MarketListing = require 'models/market-listing.coffee'
Tile = require 'models/tile.coffee'
Unserializer = require 'util/unserializer.coffee'
eventBus = require 'services/event-bus.coffee'

class GameController

  constructor: ->
    @game = new Game()
    @farmController = new FarmController @
    @playerController = new PlayerController @
    givePlayerStartingItems @game.player
    populateMarket @game.market


  update: ->
    return if @paused
    @game.timeElapsed += 1
    @farmController.update()
    if isEndOfDay @game
      @farmController.feedCrops()
      @farmController.feedAnimals()
      @farmController.handleLivableDays @farmController.getAllLivables()


  getFarm: ->
    @game.player.farm

  togglePause: ->
    @paused = not @paused


  saveGame: ->
    localStorage.setItem 'game-save', JSON.stringify @game
    eventBus.trigger(eventBus.events.SAVE)


  loadGame: ->
    savedState = JSON.parse localStorage.getItem "game-save"
    @game = (new Unserializer()).unserialize savedState
    eventBus.trigger(eventBus.events.LOAD)


module.exports = GameController


createStartingFarm = ->
  _.map _.range(3), ->
    _.map _.range(3), ->
      new Tile()


givePlayerStartingItems = (player) ->
  player.farm.animals = [DataService.createAnimal 'goat']
  player.farm.tiles = createStartingFarm()
  player.money = 100
  player.items = [
    DataService.createItem 'grassSeed', 5
    DataService.createItem 'goatManure', 5
    DataService.createItem 'wateringCan', 5
    DataService.createItem 'grass', 5
  ]

isEndOfDay = (game) ->
  return game.timeElapsed != 0 and game.timeElapsed % (60 * 24) == 0

populateMarket = (market) ->
  market.listings = [
    new MarketListing DataService.createItem('grassSeed', 3), 10
  ]
