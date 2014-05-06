package ;

import flixel.addons.tile.FlxRayCastTilemap;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxPoint;
import Freezable;

private enum BodyState {
  STAND;
  WALK;
  JUMP;
  FALL;
}

/**
 * ...
 * @author Brandon
 */
class Player extends FlxSpriteGroup {
  private var _init_gravity:Int = 500;
  private var _init_drag:Int = 400;
  private var _max_vel:Int = 200;
  private var _jump_str:Int = 400;
  private var _freeze_power:Int = 0;

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
    _body.loadGraphic("assets/images/stick.png", true, 64, 128);
    _body.animation.add("stand", [0], 0);
    _body.animation.add("walk", [2, 3], 5);
    _body.animation.add("jump", [4], 0);
    _body.animation.play("stand");
    //_body.allowCollisions = FlxObject.LEFT | FlxObject.RIGHT;
    add(_body);
    //FlxG.log.add("add player body");

    _arms = new FlxSprite(X, Y);
    _arms.loadGraphic("assets/images/stick.png", true, 64, 128);
    _arms.animation.add("stand", [6, 7], 2);
    _arms.animation.add("walk", [8, 9], 5);
    _arms.animation.add("jump", [6], 0);
    _arms.animation.add("point", [10], 0);
    _arms.animation.play("stand");
    //_arms.allowCollisions = FlxObject.NONE;
    add(_arms);
    //FlxG.log.add("add player arms");

    _body_state = BodyState.STAND;

    _ray = new Ray(0xFF3FC0B4);
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

  override public function update() {
    switch (_body_state) {
      case BodyState.STAND:
        if (FlxG.keys.anyPressed(["UP", "W"])) {
          _switchBodyState(BodyState.JUMP);
        } else if (FlxG.keys.anyPressed(["LEFT", "A", "RIGHT", "D"])) {
          _switchBodyState(BodyState.WALK);
        } else if (!_is_on_ground) {
          _switchBodyState(BodyState.FALL);
        }
      case BodyState.WALK:
        if (FlxG.keys.anyPressed(["LEFT", "A"])) {
          _moveLeft();
        } else if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
          _moveRight();
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
        if (_body.velocity.y > 0) {
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
      var obj = _state.fireRay(body_x, body_y, mouse_x, mouse_y, end_point);
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

    _arms.setPosition(_body.x, _body.y);

    if (_grabbed_crate != null) {
      var offset_x = _body.width - _grabbed_crate.width;
      if (_arms.flipX) {
        offset_x = 0.0;
      }
      _grabbed_crate.x = _body.x + offset_x;
      _grabbed_crate.y = _body.y + _body.height / 3;
    }

    if (FlxG.keys.justPressed.Q) {
      if (_grabbed_crate != null) {
        _grabbed_crate.freeze();
      }
    }
    if (FlxG.keys.justPressed.E) {
      if (_grabbed_crate != null) {
        _grabbed_crate.unfreeze();
      }
    }
  }

  private function _moveLeft() {
    _body.velocity.x = -_max_vel;
    _body.flipX = true;
    _arms.flipX = true;
  }

  private function _moveRight() {
    _body.velocity.x = _max_vel;
    _body.flipX = false;
    _arms.flipX = false;
  }

  private function _switchBodyState(new_state:BodyState) {
    switch (new_state) {
      case BodyState.STAND:
        _body.animation.play("stand");
      case BodyState.WALK:
        _body.animation.play("walk");
      case BodyState.JUMP:
        _body.velocity.y = -_jump_str;
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
    //FlxG.log.add(_body.touching);
    if (_grabbed_crate != null) return;
    if (_is_grabbing &&
        ((_body.isTouching(FlxObject.LEFT) && _arms.flipX) ||
        (_body.isTouching(FlxObject.RIGHT) && !_arms.flipX))) {
        if (crate.grab()) {
          _grabbed_crate = crate;
        }
    } else {
      _grabbed_crate = null;
    }
  }
}
