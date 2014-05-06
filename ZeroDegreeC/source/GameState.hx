package ;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxCollision;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Brandon
 */
class GameState extends FlxState {
  private var _loader:FlxOgmoLoader;
  private var _map:FlxTilemap;
  private var _tileMap:FlxTilemap;

  private var _player:Player;
  private var _crates:FlxGroup;
  private var _turrets:FlxGroup;

  private var _freeze_power:FlxText;

  public function new() {
    super();
  }

  override public function create():Void {
    add(_tileMap);
    FlxG.log.add("add tile map");
    FlxG.log.add(_tileMap.width + " " + _tileMap.height);

    _crates = new FlxGroup();
    _turrets = new FlxGroup();
    _loader.loadEntities(_loadEntity, "objects");
    add(_crates);
    add(_turrets);

    _freeze_power = new FlxText(10, 20, 200, "Freeze Power: ??");
    _freeze_power.setPosition(10, 10);
    _freeze_power.scrollFactor.set(0, 0);
    _freeze_power.color = 0x0530FA;
    add(_freeze_power);

    super.create();
  }

  override public function update():Void {
    super.update();

    _freeze_power.text = "Freeze Power: " + _player.getFreezePower();

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
    _player = new Player(0, 0, 10, this);
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

  private function _spawnTurret(x:Float, y:Float) {
    FlxG.log.add("spawn turret " + x + " " + y);
    var turret = new Turret(0, 0);
    turret.x = x - turret.width / 2;
    turret.y = y - turret.height / 2;
    _turrets.add(turret);
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
      case "Turret":
        _spawnTurret(x, y);
    }
  }

  public function fireRay(source_x:Float, source_y:Float, end_x:Float, end_y:Float, result:FlxPoint):Freezable {
    var dir_x = end_x - source_x;
    var dir_y = end_y - source_y;
    var max_length = Math.sqrt(dir_x * dir_x + dir_y * dir_y);
    dir_x /= max_length;
    dir_y /= max_length;
    var step = 10.0;
    var current_length = 1.0;
    var hit_object:Freezable = null;
    while (current_length < max_length) {
      var new_x = source_x + dir_x * current_length;
      var new_y = source_y + dir_y * current_length;
      var p = new FlxPoint(new_x, new_y);
      for (crate in _crates) {
        var o = cast(crate, Freezable);
        if (o.overlapsPoint(p)) {
          hit_object = o;
          break;
        }
      }
      for (turret in _turrets) {
        var o = cast(turret, Freezable);
        if (o.overlapsPoint(p)) {
          hit_object = o;
          break;
        }
      }
      if (hit_object != null) {
        break;
      }
      current_length += step;
    }

    var tile_point:FlxPoint = new FlxPoint();
    var end_point = new FlxPoint(source_x + dir_x * max_length, source_y + dir_y * max_length);
    var hit = _tileMap.ray(new FlxPoint(source_x, source_y), end_point, tile_point, 3);
    var hit_point = new FlxPoint(source_x + dir_x * current_length, source_y + dir_y * current_length);
    if (!hit) {
      if (hit_object == null) {
        hit_point = tile_point;
      } else {
        var dx = tile_point.x - source_x;
        var dy = tile_point.y - source_y;
        var tile_dist = Math.sqrt(dx * dx + dy *  dy);
        if (tile_dist < current_length) {
          hit_point = tile_point;
          hit_object = null;
        }
      }
    } else if (hit_object == null) {
      hit_point = end_point;
    }

    result.set(hit_point.x, hit_point.y);
    return hit_object;
  }

}
