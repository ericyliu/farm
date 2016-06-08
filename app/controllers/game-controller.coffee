DataService = require 'services/data-service.coffee'
Game = require 'models/game.coffee'
MarketListing = require 'models/market-listing.coffee'
Tile = require 'models/tile.coffee'
Unserializer = require 'util/unserializer.coffee'
EventBus = require 'util/event-bus.coffee'

FarmController = require 'controllers/farm-controller.coffee'
PlayerController = require 'controllers/player-controller.coffee'
MarketController = require 'controllers/market-controller.coffee'

class GameController

  constructor: ->
    @game = new Game()
    @controllers =
      farm: new FarmController @
      player: new PlayerController @
      market: new MarketController @
    givePlayerStartingItems @game.player
    populateMarket @game.market
    EventBus.register 'game/onViewConnect', @onViewConnected, @


  update: ->
    return if @paused
    @game.set 'timeElapsed', @game.timeElapsed + 1
    @controllers.farm.update()
    if isEndOfDay @game
      @farmController.feedCrops()
      @farmController.feedAnimals()
      @farmController.handleLivableDays @farmController.getAllLivables()


  onViewConnected: ->
    EventBus.trigger 'game/onViewConnected', @game, false


  getFarm: ->
    @game.player.farm


  togglePause: ->
    @paused = not @paused


  saveGame: ->
    localStorage.setItem 'game-save', JSON.stringify @game
    EventBus.trigger 'game/save'


  loadGame: ->
    savedState = JSON.parse localStorage.getItem "game-save"
    @game = (new Unserializer()).unserialize savedState
    EventBus.trigger 'game/load'


module.exports = GameController


createStartingFarm = ->
  _.map _.range(3), ->
    _.map _.range(3), ->
      new Tile()

givePlayerStartingItems = (player) ->
  player.farm.animals = [DataService.createAnimal 'goat']
  player.farm.tiles = createStartingFarm()
  player.money = 100
  startItems = [
    DataService.createItem 'grassSeed', 5
    DataService.createItem 'goatManure', 5
    DataService.createItem 'wateringCan', 5
    DataService.createItem 'grass', 5
  ]
  _.map startItems, (item) ->
    player.addItem item

isEndOfDay = (game) ->
  return game.timeElapsed != 0 and game.timeElapsed % (60 * 24) == 0

populateMarket = (market) ->
  market.addListings [
    new MarketListing item: DataService.createItem('grassSeed', 3), price: 10
  ]
