package
{
	import org.flixel.FlxSprite;
	
	public class OnetimeSprite extends FlxSprite
	{		
		private static const ANIMATION_NAME:String = "onetime";
		private var _playing:Boolean;
		
		public function OnetimeSprite(x:Number, y:Number, pic:Class, width:Number, height:Number, frames:Array)
		{
			super(x, y, null);
			loadGraphic(pic, true, false, width, height);
			addAnimation(ANIMATION_NAME, frames, 5, false);
			play(ANIMATION_NAME);
		}
		
		override public function update():void {
			if (finished) {
				kill();
				destroy();
			}
		}
	}
}