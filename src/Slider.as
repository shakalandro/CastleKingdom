package
{
	import org.flixel.*;
	
	public class Slider extends FlxGroup
	{
		private var _box:FlxSprite;
		private var _max:Number;
		private var _min:Number;
		private var _ball:FlxSprite;
		private var _x:Number;
		private var _y:Number;
		private var _dragging:Boolean;
		private var _dragOffset:Number;
		private var _lineThickness:Number;
		private var _numText:FlxText;
		
		public function Slider(x:Number, y:Number, width:Number, height:Number, min:Number = 1, max:Number = 100, lineThickness:Number = 3)
		{
			super(0);
			_max = max;
			_min = min;
			_x = x;
			_y = y;
			_lineThickness = lineThickness;
			_box = new FlxSprite(x, y);
			_box.makeGraphic(width, height, 0x00ffffff, false);
			_box.drawLine(2, height / 4, 1, height - height / 4,FlxG.BLACK, lineThickness + 1);
			_box.drawLine(0, height / 2, width, height / 2, FlxG.BLACK, lineThickness + 1);
			_box.drawLine(width - lineThickness + 1, height / 4, width - lineThickness + 1, height - height / 4,FlxG.BLACK, lineThickness + 1);
			add(_box);
			
			_ball = new FlxSprite(0, y + height / 2 - height / 8);
			_ball.makeGraphic(height / 4, height / 4, 0xff777777, true);
			add(_ball);
			
			_numText = new FlxText(0, 0, 100, _min + "");
			_numText.x = _ball.x + _ball.width / 2 - _numText.width / 2;
			_numText.y = _ball.y + _ball.height + 10;
			_numText.color = FlxG.BLACK;
			_numText.size = 18;
			_numText.alignment = "center";
			add(_numText);
		}
		
		override public function preUpdate():void {
			var xPos:Number = FlxG.mouse.getScreenPosition().x;
			if (FlxG.mouse.justPressed() && Util.checkClick(_ball)) {
				_dragging = true;
				_dragOffset = xPos - _ball.x;
			} else if (_dragging && FlxG.mouse.justReleased()) {
				_dragging = false;
			}
			if (_dragging) {
				_ball.x = xPos - _dragOffset;
			}
			if (_ball.x < _box.x + _lineThickness) {
				_ball.x = _box.x + _lineThickness;
			} else if (_ball.x > _box.x + _box.width - _ball.width - _lineThickness) {
				_ball.x = _box.x + _box.width - _ball.width - _lineThickness;
			}
		}
		
		override public function update():void {
			_numText.x = _ball.x + _ball.width / 2 - _numText.width / 2;
			_numText.text = value + "";
		}
		
		public function get value():Number {
			if (_ball.x == _box.x + _lineThickness) {
				return _min;
			} else if (_ball.x == _box.x + _box.width - _ball.width - _lineThickness) {
				return _max;
			} else {
				return Math.round(percent * (_max - _min)) + _min;
			}
		}
		
		public function get percent():Number {
			return (_ball.x - _box.x) / (_box.width - _ball.width);
		}
	}
}