package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;
	
	public class MessageBox extends FlxGroup
	{
		private var _text:FlxText;
		private var _btn1:FlxButton;
		private var _btn2:FlxButton;
		private var _padding:Number;
		private var _borderThickness:Number;
		private var _borderColor:uint;
		
		public function MessageBox(title:String, button1Text:String, button1Callback:Function, 
					button2Text:String = null, button2Callback:Function = null, padding:Number = 10, borderColor:uint = FlxG.RED, borderThickness:Number = 3) {
			super(0);
			_padding = padding;	
			_borderThickness = borderThickness;
			_borderColor = borderColor;
			
			_btn1 = new FlxButton(0, 0, button1Text, function():void {
				close(button1Callback);
			});
			_btn1.x = Util.maxX - _btn1.width - _padding;
			_btn1.allowCollisions = FlxObject.NONE;
			_btn1.immovable = true;
			if (button2Text != null) {
				_btn2 = new FlxButton(0, 0, button1Text, function():void {
					close(button2Callback);
				});
				_btn2.x = _btn1.x - _btn2.width - _padding;
				_btn2.allowCollisions = FlxObject.NONE;
				_btn2.immovable = true;
			}
			if (button2Text != null) {
				_text = new FlxText(_padding + Util.minX, Util.minY + _padding, _btn2.x - _padding * 2, title);
			} else {
				_text = new FlxText(_padding + Util.minX, Util.minY + _padding, _btn1.x - _padding * 2, title);
			}
			_text.color = FlxG.BLACK;
			_text.allowCollisions = FlxObject.NONE;
			_text.immovable = true;
			
			ExternalImage.setData(new BitmapData(FlxG.width, _text.height + _padding * 2, true, 0xffffffff), "message box text");
			var box:FlxSprite = new FlxSprite(Util.minX, Util.minY, ExternalImage);
			var right:Number = box.width - _borderThickness + 1;
			var bottom:Number = box.height - _borderThickness + 1;
			box.drawLine(0, 0, right, 0, _borderColor, borderThickness);
			box.drawLine(right, 0, right, bottom, _borderColor, borderThickness);
			box.drawLine(right, bottom, 0, bottom, _borderColor, borderThickness);
			box.drawLine(0, bottom, 0, 0, _borderColor, borderThickness);
			box.allowCollisions = FlxObject.NONE;
			box.immovable = true;
			add(box);
			
			if (button2Text != null) {
				Util.centerY(_btn2, box);
				add(_btn2);
			}
			Util.centerY(_btn1, box);
			Util.centerY(_text, box);
			
			add(_btn1);
			add(_text);
		}
		
		public function close(callback:Function):void {
			if (callback != null) callback();
			this.kill();
		}
	}
}