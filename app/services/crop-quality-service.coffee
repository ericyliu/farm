CropData = require 'data/crop-data.coffee'
_ = require 'lodash'

IDEAL_MULTIPLE_OF_NUTRIENTS = 2

NUTRIENT_SCORE_WEIGHT = .5
AGE_SCORE_WEIGHT = .5

module.exports =
  calculateCropQuality: (lifespan, cropType) ->
    crop = CropData[cropType]
    totalNutrientScore = _ lifespan
      .map (dayInTheLife) ->
        scoreDay(dayInTheLife)
      .reduce (sum, n) ->
        sum + n
    normalizedNutrientScore = totalNutrientScore / lifespan.length

    ageOfDeath = crop.lifeStages.death
    normalizedAgeScore = ageFunction(lifespan, ageOfDeath)

    return normalizedAgeScore * AGE_SCORE_WEIGHT + normalizedNutrientScore * NUTRIENT_SCORE_WEIGHT

scoreDay = (dayInTheLife) ->
  requiredNutrients = dayInTheLife.required_nutrients
  givenNutrients = dayInTheLife.given_nutrients
  totalNutrientScore = 0
  # calculate the score for each nutrient
  _.forOwn requiredNutrients, (nutrientAmount, nutrientKey) ->
    idealNutrientAmount = nutrientAmount * IDEAL_MULTIPLE_OF_NUTRIENTS
    givenAmount = givenNutrients[nutrientKey] || 0
    totalNutrientScore += nutrientFunction(idealNutrientAmount, givenAmount)
  # the total day score is the average of each of the nutrient scores
  return totalNutrientScore / _.size(requiredNutrients)

# the closer given nutrients are to the ideal amount, the better the score
nutrientFunction = (idealNutrientAmount, nutrientAmount) ->
  leftSideFun = (idealNutrientAmount, nutrientAmount) ->
    return nutrientAmount / idealNutrientAmount
  rightSideFun = (idealNutrientAmount, nutrientAmount) ->
    slope = -1 / idealNutrientAmount
    offset = 1 - slope * idealNutrientAmount
    return nutrientAmount * slope + offset
  # 2x idealNutrientAmount because thats where the function result becomes 0
  # needs to change if the formula changes
  if (nutrientAmount < 0 || nutrientAmount > 2 * idealNutrientAmount)
    throw new Error("Nutrient amount is invalid")
  if (nutrientAmount < idealNutrientAmount)
    return leftSideFun(idealNutrientAmount, nutrientAmount)
  else
    return rightSideFun(idealNutrientAmount, nutrientAmount)

ageFunction = (lifespan, ageOfDeath) ->
  age = lifespan.lenth
  if (age < 0 || lifespan > ageOfDeath)
    throw new Error('This crop has an invalid age')
  # we dont want to divide by ageOfDeath, because then getting a perfect score
  # would require having the plant be dead which doesnt make sense
  if ageOfDeath == 1 then return 1 else lifespan.length / (ageOfDeath - 1)
