package ;
import flixel.FlxSprite;

/**
 * @author Brandon
 */

enum FreezeLevel {
  ZERO;
  ONE;
  TWO;
}

class Freezable extends FlxSprite {
  private var _freeze_level:FreezeLevel;

  public function new(X:Float=0, Y:Float=0) {
    super(0, 0);
    this.x = X;
    this.y = Y;
    _freeze_level = FreezeLevel.ZERO;
  }

  public function freezeLevel():FreezeLevel {
    return _freeze_level;
  }

  /**
	 * Increases the freeze level if below TWO.
   *
   * @return true if the freeze_level changed.
	 */
  public function freeze():Bool {
    switch (_freeze_level) {
      case FreezeLevel.ZERO:
        _freeze_level = FreezeLevel.ONE;
        onOneFromZero();
        return true;
      case FreezeLevel.ONE:
        _freeze_level = FreezeLevel.TWO;
        onTwo();
        return true;
      case FreezeLevel.TWO:
        return false;
    }
  }

  /**
	 * Decreases the freeze level if above ZERO.
   *
   * @return true if the freeze_level changed.
	 */
  public function unfreeze():Bool {
    switch (_freeze_level) {
      case FreezeLevel.ZERO:
        return false;
      case FreezeLevel.ONE:
        _freeze_level = FreezeLevel.ZERO;
        onZero();
        return true;
      case FreezeLevel.TWO:
        _freeze_level = FreezeLevel.ONE;
        onOneFromTwo();
        return true;
    }
  }

  public function onZero():Void { }
  public function onOneFromZero():Void { }
  public function onOneFromTwo():Void { }
  public function onTwo():Void { }
}
