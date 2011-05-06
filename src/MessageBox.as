package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxGroup;
	import org.flixel.FlxText;
	
	public class MessageBox extends FlxGroup
	{
		private var _text:FlxText;
		private var _btn1:FlxButton;
		private var _btn2:FlxButton;
		private var _padding:Number;
		
		public function MessageBox(title:String, button1Text:String, button1Callback:Function, 
								   button2Text:String = null, button2Callback:Function = null, padding:Number = 10) {
			super(0);
			_padding = padding;
			_btn1 = new FlxButton(0, 0, button1Text, button1Callback);
			_btn1.x = Util.maxX - _btn1.width - _padding;
			_btn2 = new FlxButton(0, 0, button1Text, button1Callback);
			
			_text = new FlxText(0, 0, FlxG.width, title);
		}
	}
}