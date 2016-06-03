classMap =
  'DayInTheLife': require 'models/day-in-the-life.coffee'
  'Livable': require 'models/livable.coffee'


fn = (className) ->
  classMap[className]

module.exports = fn
