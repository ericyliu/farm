let Livable = require('models/livable.js');

describe('Livable', function() {
  beforeEach(function() {
    return this.livable = new Livable({
      id:'goat',
      dailyNutrientsNeeded:{grass: 1},
      harvestables: [],
      lifeStages: {child: 3}});});

  describe('isAlive', function() {
    it('is alive after 0 days', function() {
      return expect(this.livable.isAlive()).to.eql(true);
    });

    return it('dies if not fed first day', function() {
      this.livable.handleDay();
      return expect(this.livable.isAlive()).to.eql(false);
    });
  });

  describe('isAlive with feeding', () =>
    it('stays alive with good feeding', function() {
      this.livable.giveNutrients({grass: 1});
      this.livable.handleDay();
      expect(this.livable.isAlive()).to.eql(true);
      this.livable.handleDay();
      return expect(this.livable.isAlive()).to.eql(false);
    })
  );

  return describe('giveNutrients', () =>
    it('gets nutrients', function() {
      this.livable.giveNutrients({grass: 3, water: 3});
      expect(this.livable.getCurrentState()).to.eql({grass: 3});
      this.livable.handleDay();
      return expect(this.livable.getCurrentState()).to.eql({grass: 2});
    })
  );
});
