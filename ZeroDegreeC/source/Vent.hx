package ;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author Brandon
 */
class Vent extends Freezable {

  public function new(state:GameState, x:Float=0, y:Float=0) {
    super(state, x, y, "assets/images/vent.png");
    this.allowCollisions = FlxObject.NONE;
    this.immovable = true;
  }

  override public function onZero():Void {
    FlxG.log.add("vent zero");
    this.allowCollisions = FlxObject.NONE;
  }

  override public function onOneFromZero():Void {
    FlxG.log.add("vent one from zero " + this.color);
    this.allowCollisions = FlxObject.ANY;
  }

  override public function onOneFromTwo():Void {
    FlxG.log.add("vent one from two");
  }

  override public function onTwo():Void {
    FlxG.log.add("vent two");
  }
}
