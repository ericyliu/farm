DataController = require 'controllers/data-controller.coffee'
Livable = require 'models/livable.coffee'
Plant = require 'models/plant.coffee'

console.log DataController.createAnimal 'goat'

console.log 'hello world'


cat = new Livable "cat", {'grass': 10, 'water': 3}, {}
cat.giveFood {'grass': 11, 'water': 4}
cat.handleDay()
cat.giveFood {'grass': 1, 'water': 1}
cat.handleDay()
cat.giveFood {'grass': 1, 'water': 1}
cat.handleDay()
console.log cat.getCurrentState()
console.log cat.isAlive()
