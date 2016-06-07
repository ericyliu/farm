Player = require 'models/player.coffee'
Farm = require 'models/farm.coffee'
Market = require 'models/market.coffee'

class Game

  constructor: (@name = 'Player 1') ->
    super()
    @_className = 'Game'
    @player = new Player @name, new Farm()
    @timeElapsed = 0
    @market = new Market()


module.exports = Game
