CropData = require 'data/crop-data.coffee'
ItemData = require 'data/item-data.coffee'
_ = require 'lodash'

describe 'CropData', ->
  it 'harvestables all have corresponding item', ->
    harvestableKeys = _ CropData
      .map (crop) -> crop.harvestables
      .map (harvestables) -> _.keys(harvestables)
      .flatten()
      .uniq()
      .value()
    expect(ItemData).to.include.keys(harvestableKeys)
