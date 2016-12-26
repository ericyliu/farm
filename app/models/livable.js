let Base = require('models/base.js');
let _ = require('lodash');
let DayInTheLife = require('models/day-in-the-life.js');
let Constants = require('data/constants.js');

class Livable extends Base {

  /*
  @param string type - the type of livable eg. "goat"
  @param {string nutrientType: int amount} dailyNutrientsNeeded - the nutrient used up by the livable everyday
  @param [harvestable] harvestables - the resources you can get from this livable
  @param {string stage : int days in that stage} lifeStages - the different stages of life that an
    that a given livable has
  */
  constructor(options) {
    super(options);
  }


  spec() {
    return {
      _className: 'Livable',

      type: null,
      dailyNutrientsNeeded: null,
      harvestables: null,
      lifeStages: null,
      willEat: null,
      //private
      lifespan: [], // DayInTheLife[]
      todaysNutrientsGiven: {},
      wasKilled: false,
      lifeStage: Constants.lifeStage.baby,
      abilities: []
    };
  }


  update() {
    updateHarvestables(this.harvestables);
    return this.getCurrentLifeStage();
  }


  kill() {
    this.set('wasKilled', true);
    return this.getCurrentLifeStage();
  }


  harvest(harvestable) {
    harvestable.reset();
    // muahahaha
    if (harvestable.doesKillOnHarvest()) { return this.kill(); }
  }


  /*
  used to take all the things that happened in a day and save its state.
  also resets the livable for the next day
  */
  handleDay() {
    if (!this.isAlive()) { return; }
    this.lifespan.push((new DayInTheLife({required_nutrients: this.dailyNutrientsNeeded, given_nutrients: this.todaysNutrientsGiven})));
    return this.set('todaysNutrientsGiven', {});
  }

  /*
  @param {string nutrientType: int amount} allNutrientGiven - the nutrient given to an animal.
    can be called multiple times per day and will get merged together at days end
  */
  giveNutrients(allNutrientsGiven) {
    for (let nutrientId of Array.from(this.getRequiredNutrientIds())) {
      let nutrientsGiven = allNutrientsGiven[nutrientId] != null ? allNutrientsGiven[nutrientId] : 0;
      if (this.todaysNutrientsGiven[nutrientId] == null) { this.todaysNutrientsGiven[nutrientId] = 0; }
      this.todaysNutrientsGiven[nutrientId] += nutrientsGiven;
    }
    return this.set('todaysNutrientsGiven', this.todaysNutrientsGiven);
  }

  /*
  @retrun {sting nutrientType: int amount} the nutrient that the plant wants for the day
  */
  getDesiredNutrients() {
    return this.dailyNutrientsNeeded;
  }


  /*
  @return {string nutrientType: int amount} - the state of a livabele at any given time
  */
  getCurrentState() {
    let requiredNutrients = {};
    for (var nutrientId of Array.from(this.getRequiredNutrientIds())) {
      let todaysNutrients = this.todaysNutrientsGiven[nutrientId];
      requiredNutrients[nutrientId] = todaysNutrients != null ? todaysNutrients : 0;
    }

    let reducer = (result, dayInTheLife, index) => {
      let netDayInTheLife = dayInTheLife.getNetResult();
      for (nutrientId of Array.from(this.getRequiredNutrientIds())) {
        result[nutrientId] += netDayInTheLife[nutrientId];
      }
      return result;
    };
    return _.reduce(this.lifespan, reducer, requiredNutrients);
  }


  /*
  Used to determine if a livable is alive. meaning there was never a day when
  one of its requiredNutrient amounts went to 0
  @return bool
  */
  isAlive() {
    if (this.wasKilled) { return false; }
    if (this.getAge() === 0) { return true; }
    let currentState = this.getCurrentState();
    for (let nutrientId of Array.from(this.getRequiredNutrientIds())) {
      if (currentState[nutrientId] < 0) {
        return false;
      }
    }
    return true;
  }


  /*
  @return int - the age of the livable in days
  */
  getAge() {
    return this.lifespan.length;
  }


  /*
  @return string - the current life stage of a livable
  */
  getCurrentLifeStage() {
    let lifeStage;
    if (!this.isAlive()) {
      lifeStage = Constants.lifeStage.death;
    } else {
      let age = this.getAge();
      let reducer = function(result, lifeStageLength, lifeStage) {
        if (lifeStageLength <= age) {
          return lifeStage;
        } else {
          return result;
        }
      };
      lifeStage = _.reduce(this.lifeStages, reducer, Constants.lifeStage.baby);
    }
    if (lifeStage !== this.lifeStage) {
      this.set('lifeStage', lifeStage);
      _.map(this.harvestables, harvestable => harvestable.handleLivableLifeStageChange(lifeStage));
    }
    return lifeStage;
  }


  getRequiredNutrientIds() {
    return Object.keys(this.dailyNutrientsNeeded);
  }
}


var updateHarvestables = harvestables =>
  _.map(harvestables, harvestable => harvestable.update())
;


module.exports = Livable;
