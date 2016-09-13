Base = require 'models/base.coffee'

class Item extends Base

  # type: string
  # amount: int
  # quality: int - the quality of the item. this is a number between 1 and 10
  #                     and in most cases should be around 5. A 10 should be almost
  #                     impossible to get
  constructor: (options) ->
    super(options)


  # twhyte probably need to refactor. item should probably store type, then
  # a json blob of attributes
  spec: () ->
    _className: 'Item'

    type: null
    quality: null
    price: null
    category: 'unspecified_category'
    lifespan: null
    #private


module.exports = Item
