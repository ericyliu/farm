_ = require 'lodash'

class Player

  constructor: (@name, @farm, @money = 0, @items = []) ->
    @_className = 'Player'


  addItem: (item) ->
    existingItem = _.find @items, (i) -> i.type is item.type and i.quality is i.quality
    return existingItem.amount += 1 if existingItem
    @items = _.concat @items, item


  removeItem: (item) ->
    if item.amount is 1 then _.remove @items, (i) -> i is item
    else item.amount -= 1


module.exports = Player
