FarmController = require 'controllers/farm-controller.coffee'

describe 'FarmController', ->
  beforeEach ->
    @farm = animals: ['livable1']
    @tiles = [
        crop: 'livable2'
      ,
        crop: 'livable3'
      ,
        crop: undefined
    ]
    @gameController =
      getFarm: sinon.stub().returns @farm
      getTiles: sinon.stub().returns @tiles
    @controller = new FarmController @gameController


  describe 'getAllLivables', ->
    beforeEach ->
      @livables = @controller.getAllLivables()

    it 'gets all livables', ->
      @livables = ['livable1', 'livable2', 'livable3']
