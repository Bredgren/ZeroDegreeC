package ;

import flixel.FlxG;
import flixel.FlxSprite;

enum TurretState {
  PATROL;
  LOCKING_ON;
  LOCKED_ON;
  LOST_SIGHT;
}

/**
 * ...
 * @author Brandon
 */
class Turret extends Freezable {
  private var _state:TurretState = PATROL;
  private var _min_angle:Float;
  private var _max_angle:Float;
  private var _original_speed:Float;
  private var _speed:Float;
  private var _dir:Int;

  public function new(X:Float=0, Y:Float=0) {
    super(X, Y);
		this.loadGraphic("assets/images/turret.png", true, 48, 48);
    this.animation.add("Zero", [0]);
    this.animation.add("One", [1]);
    this.animation.add("Two", [2]);
    this.animation.play("Zero");
    this.immovable = true;

    _min_angle = -90;
    _max_angle = 90;
    _original_speed = _speed = 2;
    _dir = 1;
  }

  override public function update():Void {
    switch (_state) {
      case PATROL:
        this.set_angle(this.angle + _dir *_speed);
        if (this.angle < _min_angle) {
          this.set_angle(_min_angle);
          _dir = -_dir;
        } else if (this.angle > _max_angle) {
          this.set_angle(_max_angle);
          _dir = -_dir;
        }
      case LOCKING_ON:
      case LOCKED_ON:
      case LOST_SIGHT:
    }

    super.update();
  }

  override public function onZero():Void {
    FlxG.log.add("turret zero");
    this.animation.play("Zero");
    this.color = 0xFFFFFFFF;
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("turret one from zero");
    this.animation.play("One");
    this.color = 0xFF92EFEB;
    _speed = _original_speed / 2;
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("turret one from two");
    this.animation.play("One");
    this.color = 0xFF92EFEB;
    _speed = _original_speed / 2;
  }

  override public function onTwo():Void {
    FlxG.log.add("turret two");
    this.animation.play("Two");
    this.color = 0xFF0380FC;
    _speed = 0;
  }
}
