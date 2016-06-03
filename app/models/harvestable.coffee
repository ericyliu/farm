class Harvestable

  constructor: (@type, @amount, @cooldown, @onDeath = true) ->
    @maxCooldown = @cooldown


module.exports = Harvestable
