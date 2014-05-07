package ;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Brandon
 */
class IceBlock extends Freezable {
  private var _object:Freezable;

  public function new(X:Float=0, Y:Float=0) {
    super(X, Y);
    FlxG.log.add("new ice block " + X + " " + Y);
    this.loadGraphic("assets/images/ice_block.png", true, 40, 40);
    this.animation.add("One", [0]);
    this.animation.add("Two", [1]);
    setPosition(X, Y);
  }

  override public function update():Void {
    super.update();
    this.setPosition(this._object.x + this._object.width / 2, this._object.y + this._object.height / 2);
  }

  override public function reset(X:Float, Y:Float):Void {
    super.reset(X, Y);
    setPosition(X, Y);
  }

  override public function setPosition(X:Float = 0, Y:Float = 0):Void {
    this.x = X - this.width / 2;
    this.y = Y - this.height / 2;
  }

  override public function freeze():Bool {
    if (_object != null) {
      _object.freeze();
    }
    return super.freeze();
  }

  override public function unfreeze():Bool {
    if (_object != null) {
      _object.unfreeze();
    }
    return super.unfreeze();
  }

  public function setObject(object:Freezable):Void {
    _object = object;
  }

  override public function onZero():Void {
    FlxG.log.add("ice block zero");
    this.kill();
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("ice block one from zero");
    this.animation.play("One");
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("ice block one from two");
    this.animation.play("One");
  }

  override public function onTwo():Void {
    FlxG.log.add("ice block two");
    this.animation.play("Two");
  }
}
