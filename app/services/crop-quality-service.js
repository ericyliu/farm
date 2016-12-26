let CropData = require('data/crop-data.js');
let _ = require('lodash');

let IDEAL_MULTIPLE_OF_NUTRIENTS = 2;

let NUTRIENT_SCORE_WEIGHT = .5;
let AGE_SCORE_WEIGHT = .5;

module.exports = {
  calculateCropQuality(lifespan, cropType) {
    let crop = CropData[cropType];
    let totalNutrientScore = _(lifespan)
      .map(dayInTheLife => scoreDay(dayInTheLife))
      .reduce((sum, n) => sum + n);
    let normalizedNutrientScore = totalNutrientScore / lifespan.length;

    let ageOfDeath = crop.lifeStages.death;
    let normalizedAgeScore = ageFunction(lifespan, ageOfDeath);

    return (normalizedAgeScore * AGE_SCORE_WEIGHT) + (normalizedNutrientScore * NUTRIENT_SCORE_WEIGHT);
  }
};

var scoreDay = function(dayInTheLife) {
  let requiredNutrients = dayInTheLife.required_nutrients;
  let givenNutrients = dayInTheLife.given_nutrients;
  let totalNutrientScore = 0;
  // calculate the score for each nutrient
  _.forOwn(requiredNutrients, function(nutrientAmount, nutrientKey) {
    let idealNutrientAmount = nutrientAmount * IDEAL_MULTIPLE_OF_NUTRIENTS;
    let givenAmount = givenNutrients[nutrientKey] || 0;
    return totalNutrientScore += nutrientFunction(idealNutrientAmount, givenAmount);
  });
  // the total day score is the average of each of the nutrient scores
  return totalNutrientScore / _.size(requiredNutrients);
};

// the closer given nutrients are to the ideal amount, the better the score
var nutrientFunction = function(idealNutrientAmount, nutrientAmount) {
  let leftSideFun = (idealNutrientAmount, nutrientAmount) => nutrientAmount / idealNutrientAmount;
  let rightSideFun = function(idealNutrientAmount, nutrientAmount) {
    let slope = -1 / idealNutrientAmount;
    let offset = 1 - (slope * idealNutrientAmount);
    return (nutrientAmount * slope) + offset;
  };
  // 2x idealNutrientAmount because thats where the function result becomes 0
  // needs to change if the formula changes
  if (nutrientAmount < 0 || nutrientAmount > 2 * idealNutrientAmount) {
    throw new Error("Nutrient amount is invalid");
  }
  if (nutrientAmount < idealNutrientAmount) {
    return leftSideFun(idealNutrientAmount, nutrientAmount);
  } else {
    return rightSideFun(idealNutrientAmount, nutrientAmount);
  }
};

var ageFunction = function(lifespan, ageOfDeath) {
  let age = lifespan.lenth;
  if (age < 0 || lifespan > ageOfDeath) {
    throw new Error('This crop has an invalid age');
  }
  // we dont want to divide by ageOfDeath, because then getting a perfect score
  // would require having the plant be dead which doesnt make sense
  if (ageOfDeath === 1) { return 1; } else { return lifespan.length / (ageOfDeath - 1); }
};
