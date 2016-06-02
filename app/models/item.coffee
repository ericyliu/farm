class Item

  # type: string
  # amount: int
  # qualityLevel: int - the quality of the item. this is a number between 1 and 10
  #                     and in most cases should be around 5. A 10 should be almost
  #                     impossible to get
  constructor: (@type, @amount = 1, qualityLevel = 5) ->


module.exports = Item
