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
    _body.animation.add("stand", [0], 3);
    _body.animation.play("stand");
    add(_body);
    FlxG.log.add("add player body");
  }

  public function getBody():FlxSprite {
    return _body;
  }

  override public function update() {
    if (FlxG.keys.anyPressed(["LEFT", "A"])) {
      _body.velocity.x = -_max_vel;
    }
    if (FlxG.keys.anyPressed(["RIGHT", "D"])) {
      _body.velocity.x = _max_vel;
    }
    if (_body.velocity.y == 0 && FlxG.keys.anyPressed(["UP", "W"])) {
      _body.velocity.y = -_jump_str;
      _jumping = true;
    }
    // TODO: proper ground detection
    if (_jumping && _body.velocity.y == 0) {
      _jumping = false;
    }

    super.update();
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
