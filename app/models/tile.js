let _ = require('lodash');
let Base = require('models/base.js');

class Tile extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Tile',

      nutrients: {},
      crop: null
    };
  }
    // private


  update() {}


  addNutrients(nutrients) {
    return _.map((nutrients), (amount, type) => this.addNutrient(amount, type));
  }


  addNutrient(amount, type) {
    if (this.nutrients[type] == null) {
      this.nutrients[type] = amount;
    } else {
      this.nutrients[type] += amount;
    }
    return this.set('nutrients', this.nutrients);
  }


  takeNutrients(nutrients) {
    return _.mapValues((nutrients), (amount, type) => this.takeNutrient(amount, type));
  }


  takeNutrient(amount, type) {
    if (!this.nutrients[type]) { return 0; }
    // this needs to make sure the tile has enough nutrients
    let giveAmount = Math.min(amount, this.nutrients[type]);
    this.nutrients[type] -= giveAmount;
    this.set('nutrients', this.nutrients);
    return giveAmount;
  }
}


module.exports = Tile;
