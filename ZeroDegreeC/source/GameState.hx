package ;

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
  private var _tileMap:FlxTilemap;

  private var _player:Player;
  private var _crates:FlxGroup;

  private var _freeze_power:FlxText;

  public function new() {
    super();
  }

  override public function create():Void {
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
  }

  public function fireRay(source_x:Float, source_y:Float, end_x:Float, end_y:Float, result:FlxPoint):FlxObject {
    var dir_x = end_x - source_x;
    var dir_y = end_y - source_y;
    var max_length = Math.sqrt(dir_x * dir_x + dir_y * dir_y);
    dir_x /= max_length;
    dir_y /= max_length;
    var step = 10.0;
    var current_length = 1.0;
    var hit_crate:Crate = null;
    while (current_length < max_length) {
      var new_x = source_x + dir_x * current_length;
      var new_y = source_y + dir_y * current_length;
      for (crate in _crates) {
        var c = cast(crate, Crate);
        if (c.overlapsPoint(new FlxPoint(new_x, new_y))) {
          hit_crate = c;
          break;
        }
      }
      if (hit_crate != null) {
        break;
      }
      current_length += step;
    }

    var tile_point:FlxPoint = new FlxPoint();
    var end_point = new FlxPoint(source_x + dir_x * max_length, source_y + dir_y * max_length);
    var hit = _tileMap.ray(new FlxPoint(source_x, source_y), end_point, tile_point, 3);

    var hit_point = new FlxPoint(source_x + dir_x * current_length, source_y + dir_y * current_length);
    if (!hit) {
      if (hit_crate == null) {
        hit_point = tile_point;
      } else {
        var dx = tile_point.x - source_x;
        var dy = tile_point.y - source_y;
        var tile_dist = Math.sqrt(dx * dx + dy *  dy);
        if (tile_dist < current_length) {
          hit_point = tile_point;
          hit_crate = null;
        }
      }
    } else if (hit_crate == null) {
      hit_point = end_point;
    }

    result.set(hit_point.x, hit_point.y);

    return hit_crate;
  }

}
