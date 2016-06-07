Base = require 'models/base.coffee'
Player = require 'models/player.coffee'
Farm = require 'models/farm.coffee'
Market = require 'models/market.coffee'

class Game extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    name: 'Player 1'
    #private
    player: new Player {name: 'Player 1', farm: new Farm()}
    timeElapsed: 0
    market: new Market()
    _className: 'Game'


module.exports = Game
