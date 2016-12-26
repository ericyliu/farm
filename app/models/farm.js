let Base = require('models/base.js');
let Tile = require('models/tile.js');
let EventBus = require('util/event-bus.js');


class Farm extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Farm',

      animals: [],
      tiles: [],
      animalTrough: new Tile()
    };
  }
    //private


  expand() {
    let newRow = _.map(_.range(_.size(this.tiles[0]) + 1), () => new Tile);
    this.tiles = _(this.tiles)
      .map(row => _.concat(row, new Tile))
      .concat([newRow])
      .value();
    return EventBus.trigger('model/Farm/expanded', this.tiles);
  }
}


module.exports = Farm;
