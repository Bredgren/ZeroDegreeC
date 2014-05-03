package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

private enum BodyState {
  STAND;
  WALK;
  JUMP;
  FALL;
}

private enum ArmState {
  STAND;
  WALK;
  JUMP;
  POINT;
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

  private var _body:FlxSprite;
  private var _arms:FlxSprite;

  private var _body_state:BodyState;
  private var _arm_state:ArmState;

  private var _jumping:Bool;

  private var _is_on_ground:Bool;

  public function new(X:Float = 0, Y:Float = 0) {
    //FlxG.log.add("create player");
    super(X, Y, 0);

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
    _arm_state = ArmState.STAND;
  }

  public function getBody():FlxSprite {
    return _body;
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
    //if (FlxG.keys.anyPressed(["LEFT", "A"])) {
      //_body.velocity.x = -_max_vel;
      //_body.flipX = true;
      //_arms.flipX = true;
      //_body.animation.play("walk");
      //_arms.animation.play("walk");
    //}
    //if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
      //_body.velocity.x = _max_vel;
      //_body.flipX = false;
      //_arms.flipX = false;
      //_body.animation.play("walk");
      //_arms.animation.play("walk");
    //}
    //if (_body.velocity.x == 0) {
      //_body.animation.play("stand");
      //_arms.animation.play("stand");
    //}
    //if (_is_on_ground /*_body.velocity.y == 0*/ && FlxG.keys.anyPressed(["UP", "W"])) {
      //_body.velocity.y = -_jump_str;
      //_jumping = true;
    //}
    //// TODO: proper ground detection
    ////if (_jumping && _is_on_ground /*_body.velocity.y == 0*/) {
      ////_jumping = false;
    ////}
//
    //if (!_is_on_ground/*_body.velocity.y != 0*/) {
      //_body.animation.play("jump");
      //_arms.animation.play("jump");
    //}

    if (FlxG.mouse.pressed) {
      var body_x = _body.getScreenXY().x + _body.width / 2;
      var body_y = _body.getScreenXY().y + _body.height / 2;
      var mouse_x = FlxG.mouse.getScreenPosition().x;
      var mouse_y = FlxG.mouse.getScreenPosition().y;
      var y = mouse_y - body_y;
      var x = mouse_x - body_x;
      var angle = Math.atan2(y, x);
      if (mouse_x < body_x) {
        _arms.flipX = true;
        angle += Math.PI;
      } else {
        _arms.flipX = false;
      }

      _arms.set_angle(angle / Math.PI * 180.0);
      _arms.animation.play("point");
    } else {
      _arms.set_angle(0);
    }

    super.update();

    //if (_jumping && _is_on_ground /*_body.velocity.y == 0*/) {
      //_jumping = false;
    //}
    _arms.setPosition(_body.x, _body.y);
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
        _arms.animation.play("stand");
      case BodyState.WALK:
        _body.animation.play("walk");
        _arms.animation.play("walk");
      case BodyState.JUMP:
        _body.velocity.y = -_jump_str;
        _body.animation.play("jump");
        _arms.animation.play("jump");
      case BodyState.FALL:
        _body.animation.play("jump");
        _arms.animation.play("jump");
    }
    _body_state = new_state;
  }

  private function _switchArmState(new_state:ArmState) {

  }

  public function getMaxVel():Int { return _max_vel; }
  public function setMaxVel(value:Int) { _max_vel = value; }
  public function getJumpSprength():Int { return _jump_str; }
  public function setJumpStrength(value:Int) { _jump_str = value; }
  public function isOnGround():Bool { return _is_on_ground; }
  public function setIsOnGround(value:Bool) { _is_on_ground = value; }
}
/*
package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;

class Player extends FlxSprite {
  private var _jumping:Bool;

  public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) {
    super(X, Y, SimpleGraphic);
    this.loadGraphic("assets/images/player.png", true, 25, 34);

    this.x = 40;
    this.y = 40;
    this.acceleration.y = 500;
    this.drag.x = 400;

    this.animation.add("default", [0, 1], 3);
    this.animation.add("jump", [2]);
    this.animation.play("default");
    _jumping = true;
  }

  override public function  update() {
    if (FlxG.keys.pressed.LEFT) {
      this.velocity.x = -150;
      this.flipX = true;
    }
    if (FlxG.keys.pressed.RIGHT) {
      this.velocity.x = 150;
      this.flipX = false;
    }
    trace(this.velocity);
    if (this.velocity.y == 0 && FlxG.keys.pressed.UP) {
      this.velocity.y = -250;
      this.animation.play("jump");
      _jumping = true;
    }

    if (_jumping && this.velocity.y == 0) {
      _jumping = false;
      this.animation.play("default");
    }

    super.update();
  }
}
*/
