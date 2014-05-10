package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * @author Brandon
 */

enum FreezeLevel {
  ZERO;
  ONE;
  TWO;
}

class Freezable extends FlxSprite {
  private var _freeze_level:FreezeLevel;
  private var _ice_block:FlxSprite;
  private var _state:GameState;
  private var _width:Float;
  private var _height:Float;

  public function new(state:GameState, x:Float = 0, y:Float = 0, graphic:Dynamic) {
    _state = state;
    super(0, 0);
    this.loadGraphic(graphic);
    _width = this.width;
    _height = this.height;
    this.x = x;
    this.y = y;
    _freeze_level = FreezeLevel.ZERO;
    _ice_block = new FlxSprite(0, 0);
    _ice_block.loadGraphic("assets/images/ice_block.png", true, 40, 40);
    _ice_block.animation.add("One", [0]);
    _ice_block.animation.add("Two", [1]);
    _ice_block.allowCollisions = FlxObject.NONE;
  }

  private function set_size(width:Float, height:Float) {
    //this.x -= (width - this.width) / 2 + 1;
    //this.y -= (height - this.height) / 2 + 1;
    //this.width = width;
    //this.height = height;
    //this.centerOffsets();
  }

  override public function update():Void {
    super.update();
    _ice_block.setPosition(this.x + this.width / 2 - _ice_block.width / 2,
                           this.y + this.height / 2 - _ice_block.height / 2);
  }

  public function freezeLevel():FreezeLevel {
    return _freeze_level;
  }

  /**
	 * Increases the freeze level if below TWO.
   *
   * @return true if the freeze_level changed.
	 */
  public function freeze():Bool {
    switch (_freeze_level) {
      case FreezeLevel.ZERO:
        _freeze_level = FreezeLevel.ONE;
        onOneFromZero();
        _ice_block.animation.play("One");
        set_size(_ice_block.width, _ice_block.height);
        _state.add(_ice_block);
        return true;
      case FreezeLevel.ONE:
        _freeze_level = FreezeLevel.TWO;
        onTwo();
        _ice_block.animation.play("Two");
        return true;
      case FreezeLevel.TWO:
        return false;
    }
  }

  /**
	 * Decreases the freeze level if above ZERO.
   *
   * @return true if the freeze_level changed.
	 */
  public function unfreeze():Bool {
    switch (_freeze_level) {
      case FreezeLevel.ZERO:
        return false;
      case FreezeLevel.ONE:
        _freeze_level = FreezeLevel.ZERO;
        onZero();
        set_size(_width, _height);
        _state.remove(_ice_block);
        return true;
      case FreezeLevel.TWO:
        _freeze_level = FreezeLevel.ONE;
        onOneFromTwo();
        _ice_block.animation.play("One");
        return true;
    }
  }

  public function onZero():Void { }
  public function onOneFromZero():Void { }
  public function onOneFromTwo():Void { }
  public function onTwo():Void { }
}
