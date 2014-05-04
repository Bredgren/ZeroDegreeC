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
  private var _crates:FlxGroup;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void {
    FlxG.log.add("create");
    FlxG.camera.bgColor = 0xFF4ABFE1;

    _loader = new FlxOgmoLoader("assets/data/test_level.oel");
    _tileMap = _loader.loadTilemap("assets/images/tile.png", 32, 32, "tiles");
    add(_tileMap);
    FlxG.log.add("add tile map");

    _loader.loadEntities(_loadEntity, "objects");

    //_player = new Player(100, 100);
    //add(_player);
    //FlxG.log.add("add player");

    //FlxG.camera.follow(_player.getBody(), FlxCamera.STYLE_PLATFORMER, null, 5);
    //FlxG.camera.followLead.x = 10;
    //FlxG.camera.followLead.y = 10;
    //FlxG.camera.setBounds(0, 0, _map.width, _map.height);
    //FlxG.camera.setBounds( -1000, -1000, 2000, 2000);

    //_crate = new Crate(300, 300);
    //add(_crate);

    _crates = new FlxGroup();
    add(_crates);
    for (i in 0...10) {
      var crate = new FlxSprite(100 + 40 * i, 100);
      FlxG.log.add(crate);
      crate.loadGraphic("assets/images/crate.png");
      _crates.add(crate);
    }

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

    FlxG.collide(_crates, _player, _player.touchCrate);
    FlxG.collide(_tileMap, _crates);

    if (FlxG.collide(_tileMap, _player)) {
      _player.setIsOnGround(_player.getBody().isTouching(FlxObject.DOWN));
    } else {
      _player.setIsOnGround(false);
    }
	}

  private function _spawnPlayer(x:Float, y:Float) {
    FlxG.log.add("spawn player " + x + " " + y);
    if (_player != null) {
      _player.destroy();
    }
    _player = new Player(x, y);
    add(_player);

    FlxG.camera.follow(_player.getBody(), FlxCamera.STYLE_PLATFORMER, null, 5);
  }

  private function _spawnCrate(x:Float, y:Float) {
    FlxG.log.add("spawn crate " + x + " " + y);
    //var crate = new Crate(x, y);
    //FlxG.log.add("a");
    //_crates.add(crate);
    //FlxG.log.add("b");
  }

  private function _loadEntity(entity:String, params:Xml):Void {
    FlxG.log.add(entity + ": " + params);
    switch (entity) {
      case "Player":
        _spawnPlayer(Std.parseFloat(params.get("x")), Std.parseFloat(params.get("y")));
      case "Crate":
        _spawnCrate(Std.parseFloat(params.get("x")), Std.parseFloat(params.get("y")));
    }
  }
}
