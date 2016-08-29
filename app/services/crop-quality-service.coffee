CropData = require 'data/crop-data.coffee'
_ = require 'lodash'

IDEAL_MULTIPLE_OF_NUTRIENTS = 2

module.exports =
  calculateCropQuality: (lifespan) ->
    console.log(lifespan)
    if lifespan.length < 1
      return
    totalScore = _ lifespan
      .map (dayInTheLife) ->
        scoreDay(dayInTheLife)
      .reduce (sum, n) ->
        sum + n
    return totalScore / lifespan.length

scoreDay = (dayInTheLife) ->
  leftSideFun = (idealNutrientAmount, nutrientAmount) ->
    return nutrientAmount / idealNutrientAmount
  rightSideFun = (idealNutrientAmount, nutrientAmount) ->
    slope = -1 / idealNutrientAmount
    offset = 1 - slope * idealNutrientAmount
    return nutrientAmount * slope + offset
  requiredNutrients = dayInTheLife.required_nutrients
  givenNutrients = dayInTheLife.given_nutrients
  totalNutrientScore = 0
  # calculate the score for each nutrient
  _.forOwn requiredNutrients, (nutrientAmount, nutrientKey) ->
    idealNutrientAmount = nutrientAmount * IDEAL_MULTIPLE_OF_NUTRIENTS
    givenAmount = givenNutrients[nutrientKey] || 0
    if givenAmount <= idealNutrientAmount
      totalNutrientScore += leftSideFun(idealNutrientAmount, givenAmount)
    else
      totalNutrientScore += rightSideFun(idealNutrientAmount, nutrientAmount)
  # the total day score is the average of each of the nutrient scores
  return totalNutrientScore / _.size(requiredNutrients)
