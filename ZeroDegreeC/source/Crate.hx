package ;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Brandon
 */
class Crate extends FlxSprite {

  public function new(X:Float = 0, Y:Float = 0) {
    super(X, Y);

    this.loadGraphic("assets/images/crate.png");
    this.acceleration.y = 500;
    this.drag.x = 500;
    this.elasticity = 0.2;
  }
}
