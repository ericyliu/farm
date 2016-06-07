class Item

  # type: string
  # amount: int
  # quality: int - the quality of the item. this is a number between 1 and 10
  #                     and in most cases should be around 5. A 10 should be almost
  #                     impossible to get
  constructor: (@type, @amount = 1, @quality = 5) ->
    super()
    @_className = 'Item'


module.exports = Item
