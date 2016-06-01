class Item

  # amount: int
  # type: string
  # qualityLevel: int - the quality of the item. this is a number between 1 and 10
  #                     and in most cases should be around 5. A 10 should be almost
  #                     impossible to get
  constructor: (@amount, @type, @qualityLevel) ->


module.exports = Item
