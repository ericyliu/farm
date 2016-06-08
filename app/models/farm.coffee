Base = require 'models/base.coffee'

class Farm extends Base

  constructor: (options) ->
    super(options)

  spec: () ->
    _className: 'Farm'
    
    animals: []
    tiles: []
    #private


module.exports = Farm
