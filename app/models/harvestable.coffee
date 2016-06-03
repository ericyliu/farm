class Harvestable

  constructor: (@type, @amount, @cooldown, @onDeath = true) ->
    @_className = 'Harvestable'
    @maxCooldown = @cooldown


module.exports = Harvestable
