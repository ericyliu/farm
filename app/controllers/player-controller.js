class PlayerController {

  constructor(gameController) {
    this.gameController = gameController;
  }


  getPlayer() {
    return this.gameController.game.player;
  }


  registerListeners() {}
}
    // needed by code that handles loading


module.exports = PlayerController;
