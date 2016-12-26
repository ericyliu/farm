let Base = require('models/base.js');
let Constants = require('data/constants.js');

class Harvestable extends Base {

  constructor(options) {
    super(options);

    this.maxCooldown = this.cooldown;
  }


  spec() {
    return {
      _className: 'Harvestable',

      type: null,
      amount: null,
      readyForHarvest: false,
      //private
      cooldown: null,
      maxCooldown: null
    };
  }


  // this harvestable requires killing the plant (like picking a tomato)
  doesKillOnHarvest() {
    return (this.maxCooldown == null);
  }


  reset() {
    if (this.maxCooldown != null) { this.set('cooldown', this.maxCooldown); }
    return this.set('readyForHarvest', false);
  }


  update() {
    if ((this.maxCooldown != null) && this.cooldown > 0) {
      this.set('cooldown', this.cooldown - 1);
      if (this.cooldown === 0) { return this.set('readyForHarvest', true); }
    }
  }


  handleLivableLifeStageChange(lifeStage) {
    if (lifeStage === Constants.lifeStage.adult && this.doesKillOnHarvest()) {
      return this.set('readyForHarvest', true);
    }
  }
}


module.exports = Harvestable;
