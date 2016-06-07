class Harvestable

  constructor: (@type, @amount, @cooldown, @onDeath = true) ->
    super()
    @_className = 'Harvestable'
    @maxCooldown = @cooldown


module.exports = Harvestable
