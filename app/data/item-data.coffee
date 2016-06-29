module.exports =
  dew: {}

  ################ SEEDS ################
  grassSeed:
    category: 'plantable'
    livable: 'grassCrop'

  turnipSeed:
    category: 'plantable'
    livable: 'turnipCrop'

  pumpkinSeed:
    category: 'plantable'
    livable: 'pumpkinCrop'

  tomatoSeed:
    category: 'plantable'
    livable: 'tomatoCrop'

  carrotSeed:
    category: 'plantable'
    livable: 'carrotCrop'

  parsnipSeed:
    category: 'plantable'
    livable: 'parsnipCrop'

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

  pumpkin:
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
