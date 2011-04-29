package
{	
	import flash.events.Event;
	import flash.display.LoaderInfo;
	
	import org.flixel.*;
	import org.flixel.data.FlxMouse;
	
	[SWF(width="736", height="460", backgroundColor="#ffffff")]
	//[Frame(factoryClass="Preloader")]
	
	/**
	 * This is the main CastleKingdom class.
	 * Insert game description here.
	 * 
	 * @author roy, robert, gabe, justin, kim
	 * 
	 */	
	public class CastleKingdom extends FlxGame
	{
		public static const DEBUG:Boolean = true;
		public static const FACEBOOK_ON:Boolean = true;
		
		public static const FACEBOOK_APP_ID:String = "197220693652461";
		
		public static const TILEMAP_WIDTH:int = 32;
		public static const TILEMAP_HEIGHT:int = 18;
		public static const TILE_SIZE:int = 23;
		public static const SKIN:String = Assets.SKIN_NORMAL;
		
		private static var _flashVars:Object;
				
		public function CastleKingdom()
		{
			super(736, 460, LoginState, 1);
			FlxG.mouse.show(Util.assets[Assets.CURSOR]);
			FlxG.debug = DEBUG;
			_flashVars = getFlashVars();
		}
		
		private function getFlashVars():Object {
			return LoaderInfo(this.root.loaderInfo).parameters;
		}
		
		public static function get flashVars():Object {
			return _flashVars;
		}
		
		// Disable automatic pausing
		override protected function onFocusLost(event:Event=null):void {}
	}
}
