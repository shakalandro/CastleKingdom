package
{	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	
	import org.flixel.*;
	import org.flixel.system.FlxDebugger;
	
	[SWF(width="736", height="460", backgroundColor="#ffffff")]
	[Frame(factoryClass="Preloader")]
	
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
		public static const HEIGHT:int = (TILEMAP_HEIGHT + 2) * TILE_SIZE;
		public static const WIDTH:int = TILEMAP_WIDTH * TILE_SIZE;
		public static const SKIN:String = Assets.SKIN_NORMAL;
		
		public static const FRAMERATE:uint = 45;
		public static const FRAMERATE_PAUSED:uint = 10;
		
		private static var _debug:FlxDebugger;
						
		public function CastleKingdom()
		{
			super(WIDTH, HEIGHT, LoginState, 1);
			
			FlxG.mouse.hide();
			FlxG.framerate = FRAMERATE;
			
			if (CastleKingdom.DEBUG) {
				_debug = new FlxDebugger(CastleKingdom.WIDTH, CastleKingdom.HEIGHT);
				_debug.setLayout(FlxG.DEBUGGER_BIG);
			}
		}
		
		public static function get flashVars():Object {
			return Preloader.flashVars;
		}
		
		public static function get debug():FlxDebugger {
			return _debug;
		}
		
		// Disable automatic pausing
		override protected function onFocusLost(event:Event=null):void {}
	}
}
