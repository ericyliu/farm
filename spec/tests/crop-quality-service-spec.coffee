CropQualityService = require 'services/crop-quality-service.coffee'
DayInTheLife = require 'models/day-in-the-life.coffee'

describe 'CropQualityService', ->
  it 'passes a basic sanity check', ->
    lifespan = []
    requiredNutrients = water: 3, fumono: 2
    lifespan.push(new DayInTheLife(required_nutrients: requiredNutrients, given_nutrients: {water: 3, fumono: 2}))
    cropQuality = CropQualityService.calculateCropQuality(lifespan, 'grassCrop')
    expect(cropQuality).to.be.above(0)
    expect(cropQuality).to.be.below(1)
  it 'handles bad nutrient amounts', ->
    lifespan = []
    requiredNutrients = water: -3
    lifespan.push(new DayInTheLife(required_nutrients: requiredNutrients, given_nutrients: {water: 3}))
    expect(CropQualityService.calculateCropQuality.bind(null, lifespan, 'grassCrop')).to.throw('Nutrient amount is invalid')