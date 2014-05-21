package ;

import flixel.addons.tile.FlxRayCastTilemap;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import Freezable;
import GameState;
import haxe.EnumFlags;

private enum BodyState {
  STAND;
  CROUCH;
  WALK;
  JUMP;
  FALL;
}

/**
 * ...
 * @author Brandon
 */
class Player extends FlxSpriteGroup {
  private var SPRITE_WIDTH:Int = 32;
  private var SPRITE_HEIGHT:Int = 64;
  private var HIT_WIDTH:Int = 16;
  private var HIT_HEIGHT:Int = 60;

  private var _health:Float = 0;
  private var _dmg_speed:Float = 0.05;
  private var _rev_speed:Float = 0.002;
  private var _init_gravity:Int = 600;
  private var _init_drag:Int = 2000;
  private var _max_vel:Int = 300;
  private var _accel:Int = 1000;
  private var _jump_str:Int = 250;
  private var _jump_boost:Float = 0.020;
  private var _freeze_power:Int = 0;

  private var _jumping:Bool = false;

  private var _body:FlxSprite;
  private var _arms:FlxSprite;

  private var _body_state:BodyState;

  private var _is_on_ground:Bool;
  private var _is_grabbing:Bool;

  private var _grabbed_crate:Crate;

  private var _state:GameState;

  private var _ray:Ray;
  //private var _sight_ray:Ray;

  public function new(X:Float = 0, Y:Float = 0, freeze_power:Int, state:GameState) {
    //FlxG.log.add("create player");
    super(X, Y, 0);
    _state = state;
    _freeze_power = freeze_power;

    _body = new FlxSprite(X, Y);
    _body.acceleration.y = _init_gravity;
    _body.drag.x = _init_drag;
    _body.loadGraphic("assets/images/stick_small.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);
    _body.animation.add("stand", [0], 0);
    _body.animation.add("crouch", [1], 0);
    _body.animation.add("walk", [2, 3], 5);
    _body.animation.add("jump", [4], 0);
    _body.animation.play("stand");
    _body.width = HIT_WIDTH;
    _body.height = HIT_HEIGHT;
    _body.centerOffsets();
    //_body.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT;
    add(_body);
    //FlxG.log.add("add player body");

    _arms = new FlxSprite(X, Y);
    _arms.loadGraphic("assets/images/stick_small.png", true, SPRITE_WIDTH, SPRITE_HEIGHT);
    _arms.animation.add("stand", [6, 7], 2);
    _arms.animation.add("crouch", [11], 0);
    _arms.animation.add("walk", [8, 9], 5);
    _arms.animation.add("jump", [6], 0);
    _arms.animation.add("point", [10], 0);
    _arms.animation.play("stand");
    _arms.width = HIT_WIDTH;
    _arms.height = HIT_HEIGHT;
    _arms.centerOffsets();
    _arms.allowCollisions = FlxObject.NONE;
    add(_arms);
    //FlxG.log.add("add player arms");

    _body_state = BodyState.STAND;

    _ray = new Ray(0xFF3FC0B4);
    _ray.allowCollisions = FlxObject.NONE;
    add(_ray);

    //_sight_ray = new Ray(0x553EC155);
    //_sight_ray.setThickness(1);
    //add(_sight_ray);
  }

  public function getBody():FlxSprite {
    return _body;
  }

  public function getFreezePower():Int {
    return _freeze_power;
  }

  public function getHealth():Float {
    return _health;
  }

  public function hit():Void {
    _health = Math.min(1, _health + _dmg_speed);
    FlxG.camera.shake(0.01, 0.1);
    if (_health == 1) {
      _state.onPlayerDeath();
    }
  }

  override public function update() {
    _health = Math.max(0, _health - _rev_speed);
    _body.acceleration.x = 0;
    switch (_body_state) {
      case BodyState.STAND:
        if (FlxG.keys.anyPressed(["UP", "W"])) {
          _switchBodyState(BodyState.JUMP);
        } else if (FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D"])) {
          _switchBodyState(BodyState.WALK);
        } else if (FlxG.keys.anyPressed(["DOWN", "S"])) {
          _switchBodyState(BodyState.CROUCH);
        } else if (!_is_on_ground) {
          _switchBodyState(BodyState.FALL);
        }
      case BodyState.CROUCH:
        if (FlxG.keys.anyPressed(["UP", "W"])) {
          _switchBodyState(BodyState.JUMP);
        } else if (FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D"])) {
          _switchBodyState(BodyState.WALK);
        } else if (FlxG.keys.anyJustReleased(["DOWN", "S"])) {
          _switchBodyState(BodyState.STAND);
        }
      case BodyState.WALK:
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
          _moveLeft();
        } else if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
          _moveRight();
        } else if (FlxG.keys.anyPressed(["DOWN", "S"])) {
          _switchBodyState(BodyState.CROUCH);
        }
        if (!FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D"])) {
          _switchBodyState(BodyState.STAND);
        } else if (FlxG.keys.anyJustPressed(["UP", "W"])) {
          _switchBodyState(BodyState.JUMP);
        } else if (!_is_on_ground) {
          _switchBodyState(BodyState.FALL);
        }
      case BodyState.JUMP:
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
          _moveLeft();
        } else if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
          _moveRight();
        }
        if (FlxG.keys.anyPressed(["UP", "W"]) && _jumping) {
          _body.velocity.y -= _jump_str * _jump_boost;
        } else if (FlxG.keys.anyJustReleased(["UP", "W"]) && _jumping) {
          _jumping = false;
        }
        if (_body.velocity.y > -10) {
          _switchBodyState(BodyState.FALL);
        }
        if (_is_on_ground) {
          _switchBodyState(BodyState.STAND);
        }
      case BodyState.FALL:
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
          _moveLeft();
        } else if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
          _moveRight();
        }
        if (_is_on_ground) {
          _switchBodyState(BodyState.STAND);
        }
    }

    if (FlxG.keys.justReleased.SPACE) {
      _is_grabbing = false;
      _setArmsAnimation();
      var throw_factor = 1.2;
      _grabbed_crate.letGo(_body.velocity.x * throw_factor, _body.velocity.y * throw_factor);
      _grabbed_crate = null;
    }

    //var b_x = _body.x + _body.width / 2;
    //var b_y = _body.y + _body.height / 2;
    //var m_x = FlxG.mouse.getWorldPosition().x;
    //var m_y = FlxG.mouse.getWorldPosition().y;
    //var e = new FlxPoint();
    //_state.fireRay(b_x, b_y, m_x, m_y, e);
    //_sight_ray.fire(new FlxPoint(b_x, b_y), e, 0.001);

    if (FlxG.keys.pressed.SPACE) {
      _is_grabbing = true;
      _arms.flipX = _body.flipX;
      _arms.animation.play("point");
    } else if ((_freeze_power > 0 && FlxG.mouse.justPressed) || FlxG.mouse.justPressedRight) {
      var body_x = _body.getScreenXY().x + _body.width / 2;
      var body_y = _body.getScreenXY().y + _body.height / 2;
      var mouse_x = FlxG.mouse.getScreenPosition().x;
      var mouse_y = FlxG.mouse.getScreenPosition().y;
      var y = mouse_y - body_y;
      var x = mouse_x - body_x;
      var angle = Math.atan2(y, x);
      if (mouse_x < body_x) {
        _body.flipX = true;
        _arms.flipX = true;
        angle += Math.PI;
      } else {
        _body.flipX = false;
        _arms.flipX = false;
      }

      _arms.set_angle(angle / Math.PI * 180.0);
      _arms.animation.play("point");

      body_x = _body.x + _body.width / 2;
      body_y = _body.y + _body.height / 2;
      mouse_x = FlxG.mouse.getWorldPosition().x;
      mouse_y = FlxG.mouse.getWorldPosition().y;
      var end_point = new FlxPoint();
      var flags = new EnumFlags<RayCollision>();
      flags.set(RayCollision.CRATES);
      flags.set(RayCollision.TURRETS);
      flags.set(RayCollision.VENTS);
      //flags.set(RayCollision.ICE_BLOCKS);
      flags.set(RayCollision.MAP);
      flags.set(RayCollision.PLATFORMS);
      var obj = cast(_state.fireRay(body_x, body_y, mouse_x, mouse_y, end_point, flags), Freezable);
      _ray.fire(new FlxPoint(body_x, body_y), end_point, 0.08);
      if (obj != null) {
        if (FlxG.mouse.justPressed) {
          if (obj.freeze()) {
            _freeze_power--;
          }
        } else {
          if (obj.unfreeze()) {
            _freeze_power++;
          }
        }
      }
    } else {
      _arms.set_angle(0);
      _setArmsAnimation();
    }

    super.update();

    if (_body.velocity.x > _max_vel) {
      _body.velocity.x = _max_vel;
    } else if (_body.velocity.x < -_max_vel) {
      _body.velocity.x = -_max_vel;
    }

    _arms.setPosition(_body.x, _body.y);

    if (_grabbed_crate != null) {
      var offset_x = _body.width / 2;
      if (_arms.flipX) {
        offset_x = _body.width / 2 - _grabbed_crate.width;
      }
      _grabbed_crate.x = _body.x + offset_x;
      _grabbed_crate.y = _body.y + _body.height / 3;
    }
  }

  private function _moveLeft(ratio:Float = 1.0) {
    //_body.velocity.x = -_max_vel;
    _body.acceleration.x = -_accel * ratio;
    if (_body.velocity.x > 0) _body.velocity.x = 0;
    _body.flipX = true;
    _arms.flipX = true;
  }

  private function _moveRight(ratio:Float = 1.0) {
    //_body.velocity.x = _max_vel;
    _body.acceleration.x = _accel * ratio;
    if (_body.velocity.x < 0) _body.velocity.x = 0;
    _body.flipX = false;
    _arms.flipX = false;
  }

  private function _switchBodyState(new_state:BodyState) {
    switch (_body_state) {
      case BodyState.STAND:
      case BodyState.CROUCH:
        _body.width = HIT_WIDTH;
        _body.height = HIT_HEIGHT;
        _body.y -= _body.height / 2;
        _body.centerOffsets();
      case BodyState.WALK:
      case BodyState.JUMP:
      case BodyState.FALL:
    }

    switch (new_state) {
      case BodyState.STAND:
        _body.animation.play("stand");
      case BodyState.CROUCH:
        if (_grabbed_crate != null) return;
        _body.height = HIT_HEIGHT / 2;
        _body.y += _body.height;
        _body.offset.y += _body.height;
        _body.animation.play("crouch");
      case BodyState.WALK:
        _body.animation.play("walk");
      case BodyState.JUMP:
        _body.velocity.y = -_jump_str;
        //_body.velocity.y -= _jump_accel;
        //_body.acceleration.y = -_jump_accel;
        _jumping = true;
        _body.animation.play("jump");
      case BodyState.FALL:
        _body.animation.play("jump");
    }

    _body_state = new_state;
    _setArmsAnimation();
  }

  private function _setArmsAnimation() {
    switch (_body_state) {
      case BodyState.STAND:
        _arms.animation.play("stand");
      case BodyState.CROUCH:
        _arms.animation.play("crouch");
      case BodyState.WALK:
        _arms.animation.play("walk");
      case BodyState.JUMP:
        _arms.animation.play("jump");
      case BodyState.FALL:
        _arms.animation.play("jump");
    }
  }

  public function getMaxVel():Int { return _max_vel; }
  public function setMaxVel(value:Int) { _max_vel = value; }
  public function getJumpSprength():Int { return _jump_str; }
  public function setJumpStrength(value:Int) { _jump_str = value; }
  public function isOnGround():Bool { return _is_on_ground; }
  public function setIsOnGround(value:Bool) { _is_on_ground = value; }

  public function touchCrate(crate:Crate, player:FlxObject) {
    FlxG.log.add("touch " + _body.overlaps(crate) );
    if (_grabbed_crate != null) return;
    if (_is_grabbing && (_body.overlaps(crate) ||
        ((_body.isTouching(FlxObject.LEFT) && _arms.flipX) ||
        (_body.isTouching(FlxObject.RIGHT) && !_arms.flipX)))) {
        if (crate.grab()) {
          _grabbed_crate = crate;
        }
    } else {
      _grabbed_crate = null;
    }
  }
}
