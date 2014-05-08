package ;

import flixel.addons.weapon.FlxWeapon;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
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
  private var _min_angle:Float;
  private var _max_angle:Float;
  private var _range:Float;
  private var _original_speed:Float;
  private var _speed:Float;
  private var _dir:Int = 1;
  private var _game_state:GameState;
  private var _sight_ray:Ray;
  private var _search_time:Int;
  private var _weapon:FlxWeapon;

  public function new(X:Float = 0, Y:Float = 0, state:GameState,
                      min_angle:Float = 0, max_angle:Float = 180, start_angle:Float = 90,
                      range:Float = 500, speed:Float = 1) {
    super(X, Y);
    _game_state = state;
		this.loadGraphic("assets/images/turret.png");
    this.immovable = true;

    _min_angle = min_angle;
    _max_angle = max_angle;
    _speed = _original_speed = speed;
    this.set_angle(start_angle);
    _range = range;

    this.width = 25;
    this.height = 25;
    this.centerOffsets();

    _sight_ray = new Ray(0x55FF0000);
    _sight_ray.setThickness(2);
    _game_state.add(_sight_ray);

    _weapon = new FlxWeapon("turret gun", this);
    _weapon.makePixelBullet(100, 10, 10, 0xFFA8A800, Std.int(this.width / 2), Std.int(this.height / 2));
    _weapon.bounds.top = 0;
    _weapon.bounds.left = 0;
    _weapon.bounds.right = _game_state.levelWidth();
    _weapon.bounds.bottom = _game_state.levelHeight();
    _weapon.setBulletSpeed(5000);
    _weapon.setFireRate(500);
    _game_state.add(_weapon.group);
  }

  public function weapon():FlxWeapon {
    return _weapon;
  }

  override public function update():Void {
    switch (_state) {
      case PATROL:
        _updateAngle();
        var contact:FlxPoint = new FlxPoint();
        var player = _fireSightRay(contact);
        if (player != null) {
          _state = LOCKING_ON;
        }
      case LOCKING_ON:
        _state = LOCKED_ON;
      case LOCKED_ON:
        //FlxG.log.add("locked on");
        _weapon.fireFromParentAngle();
        //_weapon.fireAtMouse();
        //_weapon.fire();
        var contact:FlxPoint = new FlxPoint();
        var player = _fireSightRay(contact);
        //if (contact.y < player.y + player.height / 2) {
          //_dir = 1;
        //} else {
          //_dir = -1;
        //}
       // _updateAngle();
        if (player == null) {
          _state = LOST_SIGHT;
          _search_time = 120;
        }
      case LOST_SIGHT:
        //FlxG.log.add("lost sight");
        _search_time--;
        if (_search_time <= 0) {
          _state = PATROL;
        } else {
          if (_search_time % 50 == 0) {
            _dir = -_dir;
          }
          _updateAngle();
          var contact:FlxPoint = new FlxPoint();
          var player = _fireSightRay(contact);
          if (player != null) {
            _state = LOCKING_ON;
          }
        }
    }

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

  private function _updateAngle():Void {
    this.set_angle(this.angle + _dir *_speed);
    if (this.angle < _min_angle) {
      this.set_angle(_min_angle);
      _dir = -_dir;
    } else if (this.angle > _max_angle) {
      this.set_angle(_max_angle);
      _dir = -_dir;
    }
  }

  /*
   * @return Player if hit
   */
  private function _fireSightRay(contact:FlxPoint):Player {
    var dir_x = Math.cos(this.angle / 180.0 * Math.PI);
    var dir_y = Math.sin(this.angle / 180.0 * Math.PI);
    var start_x = this.x + this.width / 2 + dir_x * this.width / 2;
    var start_y = this.y + this.height / 2 + dir_y * this.height / 2;
    var end_x = start_x + dir_x * _range;
    var end_y = start_y + dir_y * _range;
    var flags = new EnumFlags<RayCollision>();
    flags.set(RayCollision.PLAYER);
    flags.set(RayCollision.CRATES);
    flags.set(RayCollision.MAP);
    var player = Std.instance(_game_state.fireRay(start_x, start_y, end_x, end_y, contact, flags), Player);
    _sight_ray.fire(new FlxPoint(start_x, start_y), contact, 0.001);

    return player;
  }
}
