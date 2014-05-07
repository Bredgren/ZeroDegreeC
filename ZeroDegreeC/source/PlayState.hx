package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends GameState {

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void {
    FlxG.log.add("create");
    FlxG.camera.bgColor = 0xFFC0C0C0;

    _loader = new FlxOgmoLoader("assets/data/test_level.oel");
    _tileMap = _loader.loadTilemap("assets/images/tile.png", 32, 32, "tiles");

    _max_freeze_power = 10;

		super.create();
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void {
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void {
		super.update();
  }
}
