package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxSpriteUtil.LineStyle;

/**
 * ...
 * @author Brandon
 */
class Ray extends FlxSprite {
  private var _fade_rate:Float;
  private var _color:Int;
  private var _thickness:Int = 5;

  public function new(color:Int) {
    super(0, 0);
    _color = color;
    this.kill();
  }

  public function setColor(color:Int):Void {
    _color = color;
  }

  public function setThickness(thickness:Int):Void {
    _thickness = thickness;
  }

  public function fire(start:FlxPoint, end:FlxPoint, fade_rate:Float = 0.1) {
    super.reset(0, 0);
    this._fade_rate = fade_rate;
    this.x = Math.min(start.x, end.x) - _thickness / 2;
    this.y = Math.min(start.y, end.y) - _thickness / 2;
    var width = Std.int(Math.max(Math.abs(end.x - start.x), _thickness) + _thickness / 2);
    var height = Std.int(Math.max(Math.abs(end.y - start.y), _thickness) + _thickness / 2);
    this.makeGraphic(width, height, 0x00000000);
    FlxSpriteUtil.fill(this, 0x00000000);
    var s:LineStyle = { color: _color, thickness: _thickness };
    var x1 = _thickness / 2;
    var y1 = _thickness / 2;
    var x2 = width - _thickness / 2;
    var y2 = height - _thickness / 2;
    if (start.x > end.x) {
      x1 = width - _thickness / 2;
      x2 = _thickness / 2;
    }
    if (start.y > end.y) {
      y1 = height - _thickness / 2;
      y2 = _thickness / 2;
    }

    FlxSpriteUtil.drawLine(this, x1, y1, x2, y2, s);

    this.alpha = 1.0;
  }

  override public function update():Void {
    this.alpha -= _fade_rate;
    if (this.alpha <= 0.0) {
      this.kill();
    }

    super.update();
  }
}
