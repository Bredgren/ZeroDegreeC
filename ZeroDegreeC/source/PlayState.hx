package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends GameState {
  //private var _loader:FlxOgmoLoader;
  //private var _map:FlxTilemap;

	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void {
    FlxG.log.add("create");
    FlxG.camera.bgColor = 0xFFC0C0C0;

    _loader = new FlxOgmoLoader("assets/data/test_level.oel");
    _tileMap = _loader.loadTilemap("assets/images/tile.png", 32, 32, "tiles");
    //add(_tileMap);
    //FlxG.log.add("add tile map");
    //FlxG.log.add(_tileMap.width + " " + _tileMap.height);
//
    //_crates = new FlxGroup();
//
    //_loader.loadEntities(_loadEntity, "objects");
//
    //add(_crates);

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

    //var player_collide = false;
    //if (FlxG.collide(_crates, _player, _player.touchCrate)) {
      //player_collide = true;
    //}
//
    //FlxG.collide(_crates, _crates);
    //FlxG.collide(_tileMap, _crates);
//
    //if (FlxG.collide(_tileMap, _player)) {
      //player_collide = true;
    //}
//
    //if (player_collide) {
      //_player.setIsOnGround(_player.getBody().isTouching(FlxObject.DOWN));
    //} else {
      //_player.setIsOnGround(false);
    //}
	}

  //private function _spawnPlayer(x:Float, y:Float) {
    //FlxG.log.add("spawn player " + x + " " + y);
    //_player = new Player(0, 0, 10, this);
    //_player.x = x - _player.width / 2;
    //_player.y = y - _player.height;
    //add(_player);
//
    //FlxG.camera.follow(_player.getBody(), FlxCamera.STYLE_PLATFORMER, null, 5);
  //}
//
  //private function _spawnCrate(x:Float, y:Float) {
    //FlxG.log.add("spawn crate " + x + " " + y);
    //var crate = new Crate(0, 0);
    //crate.x = x - crate.width / 2;
    //crate.y = y - crate.height;
    //_crates.add(crate);
  //}
//
  //private function _loadEntity(entity:String, params:Xml):Void {
    //FlxG.log.add(entity + ": " + params);
    //var x = Std.parseFloat(params.get("x"));
    //var y = Std.parseFloat(params.get("y"));
    //switch (entity) {
      //case "Player":
        //_spawnPlayer(x, y);
      //case "Crate":
        //_spawnCrate(x, y);
    //}
  //}
}
