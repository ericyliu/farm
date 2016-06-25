module.exports =
  dew: {}

  ################ SEEDS ################
  grassSeed:
    category: 'plantable'
    livable: 'grass'

  turnipSeed:
    category: 'plantable'
    livable: 'turnip'

  tomatoSeed:
    category: 'plantable'
    livable: 'tomato'

  carrotSeed:
    category: 'plantable'
    livable: 'carrot'

  parsnipSeed:
    category: 'plantable'
    livable: 'parsnip'

  ################ NUTRIENTS #############
  goatManure:
    category: 'fertilizer'
    nutrients: nitrogen: 5
    price: 5

  wateringCan:
    category: 'fertilizer'
    nutrients: water: 3

  fumonoFertilizer:
    category: 'fertilizer'
    nutrients: fumono: 3

  kamonoFertilizer:
    category: 'fertilizer'
    nutrients: kamono: 3

  suimonoFertilizer:
    category: 'fertilizer'
    nutrients: suimono: 3

  chimonoFertilizer:
    category: 'fertilizer'
    nutrients: chimono: 3

  ############## HARVEST #################

  grass:
    category: 'food'

  turnip:
    category: 'food'
    price: 1

  tomato:
    category: 'food'
    price: 1

  carrot:
    category: 'food'
    price: 1

  parsnip:
    category: 'food'
    price: 1
