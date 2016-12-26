let CropData = require('data/crop-data.js');
let ItemData = require('data/item-data.js');
let _ = require('lodash');

describe('CropData', () =>
  it('harvestables all have corresponding item', function() {
    let harvestableKeys = _(CropData)
      .map(crop => crop.harvestables)
      .map(harvestables => _.keys(harvestables))
      .flatten()
      .uniq()
      .value();
    return expect(ItemData).to.include.keys(harvestableKeys);
  })
);
