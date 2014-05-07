package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import haxe.EnumFlags;
import GameState;

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
  private var _min_angle:Float = -90;
  private var _max_angle:Float = 90;
  private var _range:Float = 200;
  private var _original_speed:Float = 2;
  private var _speed:Float;
  private var _dir:Int = 1;
  private var _games_state:GameState;
  private var _sight_ray:Ray;

  public function new(X:Float=0, Y:Float=0, state:GameState) {
    super(X, Y);
		this.loadGraphic("assets/images/turret.png");
    this.immovable = true;

    _min_angle = -90;
    _max_angle = 90;
    _speed = _original_speed;

    this.width = 25;
    this.height = 25;
    this.centerOffsets();

    _games_state = state;
    _sight_ray = new Ray(0xFFFF0000);
    _sight_ray.setThickness(2);
    _games_state.add(_sight_ray);
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

    var dir_x = Math.cos((this.angle + 90) / 180.0 * Math.PI);
    var dir_y = Math.sin((this.angle + 90) / 180.0 * Math.PI);
    var start_x = this.x + this.width / 2 + dir_x * this.width;
    var start_y = this.y + this.height / 2 + dir_y * this.height;
    var end_x = start_x + dir_x * _range;
    var end_y = start_y + dir_y * _range;
    var e = new FlxPoint();
    var flags = new EnumFlags<RayCollision>();
    flags.set(RayCollision.PLAYER);
    flags.set(RayCollision.CRATES);
    flags.set(RayCollision.ICE_BLOCKS);
    flags.set(RayCollision.MAP);
    _games_state.fireRay(start_x, start_y, end_x, end_y, e, flags);
    _sight_ray.fire(new FlxPoint(start_x, start_y), e, 0.001);

    super.update();
  }

  override public function onZero():Void {
    FlxG.log.add("turret zero");
    _speed = _original_speed;
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("turret one from zero");
    _speed = _original_speed / 2;
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("turret one from two");
    _speed = _original_speed / 2;
  }

  override public function onTwo():Void {
    FlxG.log.add("turret two");
    _speed = 0;
  }
}
