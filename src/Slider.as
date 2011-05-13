package
{
	import org.flixel.*;
	
	public class Slider extends FlxGroup
	{
		private var _box:FlxSprite;
		private var _max:Number;
		private var _ball:FlxSprite;
		private var _x:Number;
		private var _y:Number;
		
		public function Slider(x:Number, y:Number, width:Number, height:Number, max:Number = 100, lineThickness:Number = 3)
		{
			super(0);
			_max = max;
			_x = x;
			_y = y;
			_box = new FlxSprite(x, y);
			_box.makeGraphic(width, height, 0x00ffffff, false);
			_box.drawLine(2, height / 4, 1, height - height / 4,FlxG.BLACK, lineThickness + 1);
			_box.drawLine(0, height / 2, width, height / 2, FlxG.BLACK, lineThickness + 1);
			_box.drawLine(width - lineThickness + 1, height / 4, width - lineThickness + 1, height - height / 4,FlxG.BLACK, lineThickness + 1);
			add(_box);
			
			_ball = new FlxSprite(0, height / 2 - height / 8);
			_ball.makeGraphic(height / 4, height / 4, 0xff777777, true);
			add(_ball);
		}
		
		override public function update():void {
			if (FlxG.mouse.pressed() && Util.checkClick(_ball)) {
				Util.log("Slider clicked on");
				var xPos:Number = FlxG.mouse.getScreenPosition().x;
				//xPos += (_ball.x - xPos);
				Util.log(xPos, _ball.x, _box.x);
				//if (xPos >= _box.x && xPos <= _box.x + _box.width - _ball.width) {
					_ball.x = xPos;
				//}
			}
		}
	}
}