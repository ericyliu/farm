class Harvestable

  constructor: (@type, @amount, @cooldown, @onDeath = true) ->
    @_className = 'Harvestable'


module.exports = Harvestable
