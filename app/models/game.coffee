Player = require 'models/player.coffee'
Farm = require 'models/farm.coffee'

class Game

  constructor: (@name = 'Player 1') ->
    @_className = 'Game'
    @player = new Player @name, new Farm()
    @timeElapsed = 0


module.exports = Game
