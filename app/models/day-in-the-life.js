let Base = require('models/base.js');

class DayInTheLife extends Base {

  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'DayInTheLife',
    
      required_nutrients: null,
      given_nutrients: null
    };
  }
    // private


  getNetResult() {
    let result = {};
    for (let nutrientId of Array.from(Object.keys(this.required_nutrients))) {
      let givenNutrient = this.given_nutrients[nutrientId] != null ? this.given_nutrients[nutrientId] : 0;
      result[nutrientId] = givenNutrient - this.required_nutrients[nutrientId];
    }
    return result;
  }
}

module.exports = DayInTheLife;
