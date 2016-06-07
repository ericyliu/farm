Base = require 'models/base.coffee'

class Farm extends Base

  constructor: (options) ->
    super(options)

  spec: () ->
    animals: []
    tiles: []
    #private
    _className: 'Farm'


module.exports = Farm
