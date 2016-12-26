let FarmController = require('controllers/farm-controller.js');

describe('FarmController', function() {
  beforeEach(function() {
    this.farm = {
      animals: ['livable1'],
      tiles: [
          {crop: 'livable2'}
        ,
          {crop: 'livable3'}
        ,
          {crop: undefined}
      ]
    };
    this.gameController = {
      getFarm: sinon.stub().returns(this.farm),
      getTiles: sinon.stub().returns(this.tiles)
    };
    return this.controller = new FarmController(this.gameController);
  });


  return describe('getAllLivables', function() {
    beforeEach(function() {
      return this.livables = this.controller.getAllLivables();
    });

    return it('gets all livables', function() {
      return expect(this.livables).to.eql(['livable1', 'livable2', 'livable3']);});});});
