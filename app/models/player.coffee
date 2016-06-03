_ = require 'lodash'

class Player

  constructor: (@name, @farm, @money = 0, @items = []) ->
    @_className = 'Player'

  removeItem: (item) ->
    if item.amount is 1 then _.remove @items, (i) -> i is item
    else item.amount -= 1


module.exports = Player
