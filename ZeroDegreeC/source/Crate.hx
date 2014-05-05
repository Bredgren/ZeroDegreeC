package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import Freezable;

/**
 * ...
 * @author Brandon
 */
class Crate extends Freezable {
  private var _init_gravity:Int = 500;

  public function new(X:Float = 0, Y:Float = 0) {
    super(X, Y);

    this.loadGraphic("assets/images/crate.png");
    this.acceleration.y = _init_gravity;
    this.drag.set(200, 200);
    this.elasticity = 0.2;
  }

  /*
   * @return false if it can't be grabbed
   */
  public function grab():Bool {
    if (_freeze_level == FREEZE_LEVEL.TWO) {
      return false;
    }
    this.acceleration.y = 0;
    this.allowCollisions = FlxObject.NONE;
    return true;
  }

  public function letGo(throw_x:Float, throw_y:Float):Void {
    if (_freeze_level != FREEZE_LEVEL.TWO) {
      this.acceleration.y = _init_gravity;
      this.velocity.set(throw_x,throw_y);
    }
    this.allowCollisions = FlxObject.ANY;
  }

  override public function update():Void {
    super.update();
  }

  override public function onZero():Void {
    FlxG.log.add("zero");
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("one from zero");
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("one from two");
    this.immovable = false;
    this.acceleration.y = _init_gravity;
  }

  override public function onTwo():Void {
    FlxG.log.add("two");
    this.immovable = true;
    this.acceleration.y = 0;
  }
}
