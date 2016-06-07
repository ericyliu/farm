IdService = require 'services/id-service.coffee'

class ModelBase
  constructor: () ->
    @id = IdService.get()
