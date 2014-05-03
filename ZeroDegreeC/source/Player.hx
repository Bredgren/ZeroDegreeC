package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Brandon
 */
class Player extends FlxSpriteGroup {
  private var _init_gravity:Int = 500;
  private var _init_drag:Int = 400;
  private var _max_vel:Int = 200;
  private var _jump_str:Int = 400;

  public var _body:FlxSprite;
  private var _arms:FlxSprite;

  private var _jumping:Bool;

  public function new(X:Float = 0, Y:Float = 0) {
    FlxG.log.add("create player");
    super(X, Y, 0);

    _body = new FlxSprite(X, Y);
    _body.acceleration.y = _init_gravity;
    _body.drag.x = _init_drag;
    _body.loadGraphic("assets/images/stick.png", true, 64, 128);
    _body.animation.add("stand", [0], 0);
    _body.animation.add("walk", [2, 3], 5);
    _body.animation.add("jump", [4], 0);
    _body.animation.play("stand");
    add(_body);
    FlxG.log.add("add player body");

    _arms = new FlxSprite(X, Y);
    _arms.loadGraphic("assets/images/stick.png", true, 64, 128);
    _arms.animation.add("stand", [6, 7], 2);
    _arms.animation.add("walk", [8, 9], 5);
    _arms.animation.add("jump", [6], 0);
    _arms.animation.add("point", [10], 0);
    _arms.animation.play("stand");
    add(_arms);
    FlxG.log.add("add player arms");
  }

  public function getBody():FlxSprite {
    return _body;
  }

  override public function update() {
    if (FlxG.keys.anyPressed(["LEFT", "A"])) {
      _body.velocity.x = -_max_vel;
      _body.flipX = true;
      _arms.flipX = true;
      _body.animation.play("walk");
      _arms.animation.play("walk");
    }
    if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
      _body.velocity.x = _max_vel;
      _body.flipX = false;
      _arms.flipX = false;
      _body.animation.play("walk");
      _arms.animation.play("walk");
    }
    if (_body.velocity.x == 0) {
      _body.animation.play("stand");
      _arms.animation.play("stand");
    }
    if (_body.velocity.y == 0 && FlxG.keys.anyPressed(["UP", "W"])) {
      _body.velocity.y = -_jump_str;
      _jumping = true;
    }
    // TODO: proper ground detection
    if (_jumping && _body.velocity.y == 0) {
      _jumping = false;
    }

    if (_body.velocity.y != 0) {
      _body.animation.play("jump");
      _arms.animation.play("jump");
    }

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

    _arms.setPosition(_body.x, _body.y);
  }

  public function getMaxVel():Int { return _max_vel; }
  public function setMaxVel(value:Int) { _max_vel = value; }
  public function getJumpSprength():Int { return _jump_str; }
  public function setJumpStrength(value:Int) { _jump_str = value; }
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
