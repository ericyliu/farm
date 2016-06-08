Base = require 'models/base.coffee'

class Item extends Base

  # type: string
  # amount: int
  # quality: int - the quality of the item. this is a number between 1 and 10
  #                     and in most cases should be around 5. A 10 should be almost
  #                     impossible to get
  constructor: (options) ->
    super(options)


  spec: () ->
    _className: 'Item'
    
    type: null
    amount: 1
    quality: 5
    #private


module.exports = Item
