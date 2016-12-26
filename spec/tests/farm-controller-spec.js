let FarmController = require('controllers/farm-controller.js');
let EventBus = require('util/event-bus.js');
let Tile = require('models/tile.js');

// test setup
EventBus.clearRegisteredEvents();

describe('FarmController', function() {
  describe('getAllLivables', function() {
    it('gets all livables', function() {
      let livables = getFarmController().getAllLivables();
      expect(livables).to.eql([ 'livable1', 'livable2', 'livable3' ]);
    });
  });

  describe('plant', function() {
    it('works', function() {
      EventBus.clearRegisteredEvents();

      let farmController = getFarmController();

      let item = {};
      let crop = {};

      let tile = new Tile();
      farmController.gameController.game.player.farm.animals = [ ];
      farmController.gameController.game.player.farm.tiles = [ tile ];

      let removeItemSpy = sinon.spy();
      removeItemSpy.calledWith(item);
      farmController.gameController.game.player.removeItem = removeItemSpy;

      farmController.plant(tile, item, crop);

      assert(removeItemSpy.calledOnce);
      expect(farmController.getAllLivables()[0]).to.eql(crop);
    });
  });
});

function getFarmController() {
  return new FarmController(getGameController());
}

function getGameController() {
  let game = {
    player: {
      farm: {
        animals: [ 'livable1' ],
        tiles: [
            { crop: 'livable2' },
            { crop: 'livable3' },
            { crop: undefined }
        ]
      }
    }
  };

  return {
    game: game,
    getFarm: function() { return game.player.farm; }
  };
}
