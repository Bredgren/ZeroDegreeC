package ;
import flixel.FlxSprite;

/**
 * @author Brandon
 */

enum FREEZE_LEVEL {
  ZERO;
  ONE;
  TWO;
}

class Freezable extends FlxSprite {
  private var _freeze_level:FREEZE_LEVEL;

  public function new(X:Float = 0, Y:Float = 0) {
    super(X, Y);
    _freeze_level = FREEZE_LEVEL.ZERO;
  }

  public function freezeLevel():FREEZE_LEVEL {
    return _freeze_level;
  }

  /**
	 * Increases the freeze level if below TWO.
   *
   * @return true if the freeze_level changed.
	 */
  public function freeze():Bool {
    switch (_freeze_level) {
      case FREEZE_LEVEL.ZERO:
        _freeze_level = FREEZE_LEVEL.ONE;
        onOneFromZero();
        return true;
      case FREEZE_LEVEL.ONE:
        _freeze_level = FREEZE_LEVEL.TWO;
        onTwo();
        return true;
      case FREEZE_LEVEL.TWO:
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
      case FREEZE_LEVEL.ZERO:
        return false;
      case FREEZE_LEVEL.ONE:
        _freeze_level = FREEZE_LEVEL.ZERO;
        onZero();
        return true;
      case FREEZE_LEVEL.TWO:
        _freeze_level = FREEZE_LEVEL.ONE;
        onOneFromTwo();
        return true;
    }
  }

  public function onZero():Void { }
  public function onOneFromZero():Void { }
  public function onOneFromTwo():Void { }
  public function onTwo():Void { }
}
