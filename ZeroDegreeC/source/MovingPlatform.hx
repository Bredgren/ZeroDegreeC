package ;
import flixel.FlxG;
import flixel.util.FlxPoint;
import Freezable;

/**
 * ...
 * @author Brandon
 */
class MovingPlatform extends Freezable implements Powerable {
  var _pos1:FlxPoint;
  var _pos2:FlxPoint;
  var _speed:Float;
  var _speed1:Float;
  var _speed2:Float
  var _target:FlxPoint;

  public function new(state:GameState, pos1:FlxPoint, pos2:FlxPoint, speed1:Float, speed2:Float, start_pos1:Bool = true) {
    var x = pos1.x; var y = pos1.y;
    if (!start_pos1) {
      x = pos2.x; y = pos2.y;
    }
    super(state, x, y, "assets/images/moving_platform.png");
    _pos1 = pos1;
    _pos2 = pos2;
    _speed1 = speed1;
    _speed2 = speed2;
    _speed = speed1;
    if (start_pos1) _target = _pos1;
    else _target = _pos2;
    this.immovable = true;
    FlxG.log.add("spawned platform " + pos1 + " | " + pos2 + " | " + speed1 + " | " + speed2 + " | " + start_pos1);
  }

  public function togglePower():Void {
    if (_target == _pos1) _target = _pos2;
    else _target = _pos1;
  }

  override public function update():Void {
    this.velocity.set(0, 0);
    var dx_target = _target.x - this.x;
    var dy_target = _target.y - this.y;
    var dist_target = Math.sqrt(dx_target * dx_target + dy_target * dy_target);

    var speed = _speed;
    if (freezeLevel() == FreezeLevel.ONE) speed = _speed / 2;
    if (dist_target > 2) {
      this.velocity.x = (dx_target / dist_target) * speed;
      this.velocity.y = (dy_target / dist_target) * speed;
    } else {
      this.x = _target.x; this.y = _target.y;
    }

    super.update();
  }

  override public function onZero():Void {
    FlxG.log.add("platform zero");
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("platform one from zero " + this.color);
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("platform one from two");
  }

  override public function onTwo():Void {
    FlxG.log.add("platform two");
  }
}
