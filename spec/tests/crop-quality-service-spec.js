let CropQualityService = require('services/crop-quality-service.js');
let DayInTheLife = require('models/day-in-the-life.js');

describe('CropQualityService', function() {
  it('passes a basic sanity check', function() {
    let lifespan = [];
    let requiredNutrients = {water: 3, fumono: 2};
    lifespan.push(new DayInTheLife({required_nutrients: requiredNutrients, given_nutrients: {water: 3, fumono: 2}}));
    let cropQuality = CropQualityService.calculateCropQuality(lifespan, 'grassCrop');
    expect(cropQuality).to.be.above(0);
    return expect(cropQuality).to.be.below(1);
  });
  return it('handles bad nutrient amounts', function() {
    let lifespan = [];
    let requiredNutrients = {water: -3};
    lifespan.push(new DayInTheLife({required_nutrients: requiredNutrients, given_nutrients: {water: 3}}));
    return expect(CropQualityService.calculateCropQuality.bind(null, lifespan, 'grassCrop')).to.throw('Nutrient amount is invalid');
  });
});
