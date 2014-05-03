package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import openfl.Assets;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState {
  private var _loader:FlxOgmoLoader;
  private var _tileMap:FlxTilemap;
  private var _map:FlxTilemap;

  private var _player:Player;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void {
    FlxG.log.add("create");
    FlxG.camera.bgColor = 0xffff0000;

    _loader = new FlxOgmoLoader("assets/data/test_level.oel");
    _tileMap = _loader.loadTilemap("assets/images/tile.png", 32, 32, "tiles");
    add(_tileMap);
    FlxG.log.add("add tile map");

    _player = new Player(100, 100);
    add(_player);
    FlxG.log.add("add player");

    FlxG.camera.follow(_player.getBody(), FlxCamera.STYLE_LOCKON, null, 0);
    //FlxG.camera.setBounds(0, 0, _map.width, _map.height);
    //FlxG.camera.setBounds( -1000, -1000, 2000, 2000);

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

    FlxG.collide(_tileMap, _player);
	}
}
