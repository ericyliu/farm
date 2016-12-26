let Unserializer = require('util/unserializer.js');
let DayInTheLife = require('models/day-in-the-life.js');
let Livable = require('models/livable.js');

describe('Unserializer', function() {
  beforeEach(function() {
    return this.unserializer = new Unserializer();
  });

  return describe('unserialize', function() {
    beforeEach(function() {
      return this.livable = new Livable({
        id:'goat',
        dailyNutrientsNeeded:{grass: 1},
        harvestables: [],
        lifeStages: {child: 3}});});

    return it('unserializes a livable', function() {
      this.livable.giveNutrients({'grass': 4});
      this.livable.handleDay();
      let unserializedLivable = this.unserializer.unserialize(JSON.parse(JSON.stringify(this.livable)));
      return expect(unserializedLivable.getCurrentState()).to.eql({grass: 3});
    });
  });
});
