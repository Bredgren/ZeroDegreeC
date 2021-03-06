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
  private var _grabbed:Bool = false;

  public function new(state:GameState, x:Float = 0, y:Float = 0) {
    super(state, x, y, "assets/images/crate.png");

    this.acceleration.y = _init_gravity;
    this.drag.set(200, 200);
    this.elasticity = 0.2;
  }

  /*
   * @return false if it can't be grabbed
   */
  public function grab():Bool {
    if (_freeze_level == FreezeLevel.TWO) {
      return false;
    }
    this.acceleration.y = 0;
    this.allowCollisions = FlxObject.NONE;
    _grabbed = true;
    return true;
  }

  public function letGo(throw_x:Float, throw_y:Float):Void {
    if (_freeze_level != FreezeLevel.TWO) {
      this.acceleration.y = _init_gravity;
      this.velocity.set(throw_x,throw_y);
    }
    this.allowCollisions = FlxObject.ANY;
    _grabbed = false;
  }

  override public function update():Void {
    super.update();
  }

  override public function onZero():Void {
    FlxG.log.add("crate zero");
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("crate one from zero " + this.color);
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("crate one from two");
    this.immovable = false;
    if (!_grabbed) {
      this.acceleration.y = _init_gravity;
    }
  }

  override public function onTwo():Void {
    FlxG.log.add("crate two");
    this.immovable = true;
    this.acceleration.set(0, 0);
    this.velocity.set(0, 0);
  }
}
