package
{
	import org.flixel.*;
	
	public class StatsBox extends FlxGroup
	{
		private static const X_OFFSET:Number = 25;
		
		private var _x:Number;
		private var _y:Number;
		private var _padding:Number;
		private var _img:Class;
		private var _text:FlxText;
		public var value:Number;
		public var max:Number;
		public var width:Number;
		public var height:Number;
		
		public function StatsBox(x:Number, y:Number, img:Class, value:Number, max:Number = -1, padding:Number = 5)
		{
			super(0);
			_x = x;
			_y = y;
			_padding = padding;
			_img = img;
			this.value = value;
			this.max = max;
			
			var box:FlxSprite = new FlxSprite(_x, _y, _img);
			var textString:String = value + "";
			if (max != -1) {
				textString += "/" + max;
			}
			
			width = box.width;
			height = box.height;
			
			_text = new FlxText(_x, _y, box.width - X_OFFSET - 2 * _padding, textString);
			_text.size = 14;
			_text.color = FlxG.BLACK;
			_text.alignment = "right";
			Util.centerY(_text, box);
			_text.x = _x + padding;
			
			add(box);
			add(_text);
		}
		
		override public function update():void {
			super.update();
			var textString:String = value + "";
			if (max != -1) {
				textString += "/" + max;
				if (value >= .9 * max) {
					_text.color = FlxG.RED;
				} else {
					_text.color = FlxG.BLACK;
				}
			}
			if (textString.length > 8) {
				_text.size = 10;
			}
			_text.text = textString;
		}
	}
}