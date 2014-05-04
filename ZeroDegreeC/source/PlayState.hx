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
    FlxG.log.add(_tileMap.width + " " + _tileMap.height);

    _crates = new FlxGroup();

    _loader.loadEntities(_loadEntity, "objects");

    add(_crates);

    //_spawnPlayer(80, 400);
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

    //_crates = new FlxGroup();
    //add(_crates);
    //for (i in 0...10) {
      //var crate = new Crate(100 + 40 * i, 800);
      //FlxG.log.add(crate);
      //crate.loadGraphic("assets/images/crate.png");
      ////add(crate);
      //_crates.add(crate);
      //FlxG.log.add(_crates.length);
    //}

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

    var player_collide = false;
    if (FlxG.collide(_crates, _player, _player.touchCrate)) {
      player_collide = true;
    }

    FlxG.collide(_crates, _crates);
    FlxG.collide(_tileMap, _crates);

    if (FlxG.collide(_tileMap, _player)) {
      player_collide = true;
    }

    if (player_collide) {
      _player.setIsOnGround(_player.getBody().isTouching(FlxObject.DOWN));
    } else {
      _player.setIsOnGround(false);
    }
	}

  private function _spawnPlayer(x:Float, y:Float) {
    FlxG.log.add("spawn player " + x + " " + y);
    _player = new Player(0, 0);
    _player.x = x - _player.width / 2;
    _player.y = y - _player.height;
    add(_player);

    FlxG.camera.follow(_player.getBody(), FlxCamera.STYLE_PLATFORMER, null, 5);
  }

  private function _spawnCrate(x:Float, y:Float) {
    FlxG.log.add("spawn crate " + x + " " + y);
    var crate = new Crate(0, 0);
    crate.x = x - crate.width / 2;
    crate.y = y - crate.height;
    _crates.add(crate);
  }

  private function _loadEntity(entity:String, params:Xml):Void {
    FlxG.log.add(entity + ": " + params);
    var x = Std.parseFloat(params.get("x"));
    var y = Std.parseFloat(params.get("y"));
    switch (entity) {
      case "Player":
        _spawnPlayer(x, y);
      case "Crate":
        _spawnCrate(x, y);
    }
  }
}
