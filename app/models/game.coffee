_ = require 'lodash'
Base = require 'models/base.coffee'
Player = require 'models/player.coffee'
Farm = require 'models/farm.coffee'
Market = require 'models/market.coffee'
EventBus = require 'util/event-bus.coffee'

class Game extends Base

  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Game'

    name: 'Player 1'
    #private
    player: new Player {name: 'Player 1', farm: new Farm()}
    timeElapsed: 7 * 60
    market: new Market()


module.exports = Game
