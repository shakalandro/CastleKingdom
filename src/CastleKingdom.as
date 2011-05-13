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
		public static const DEBUG:Boolean = false;
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
		
		private static var _loading:FlxGroup;
		private static var numWaiting:int;
						
		public function CastleKingdom()
		{
			super(WIDTH, HEIGHT, LoginState, 1);
			
			_loading = new FlxGroup();
			var loadText:FlxText = new FlxText(0, 0, 200, "Loading...");
			loadText.color = FlxG.RED;
			loadText.size = 32;
			var bg:FlxSprite = new FlxSprite(0, 0);
			bg.makeGraphic(loadText.width * 1.5, loadText.height * 1.5, 0x44ffffff);
			Util.center(bg);
			Util.center(loadText);
			_loading.add(loadText);
			_loading.visible = false;
			numWaiting = 0;
			
			
			FlxG.mouse.show(Util.assets[Assets.CURSOR]);
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
		
		public static function get loading():Boolean {
			return _loading != null && _loading.visible;
		}
		
		public static function set loading(t:Boolean):void {
			if (t && _loading != null && !_loading.visible && numWaiting == 0) {
				Util.log("Loading image added");
				_loading.visible = true;
				FlxG.state.add(_loading);
			} else if (!t && _loading != null && _loading.visible && numWaiting == 0) {
				Util.log("Loading image removed");
				_loading.visible = false;
				FlxG.state.remove(_loading);
			} else {
				FlxG.state.add(FlxG.state.remove(_loading));
			}
			if (t) {
				numWaiting++;
			} else {
				numWaiting = Math.min(numWaiting - 1, 0);
			}
			Util.log("Loading count: ", numWaiting, _loading != null);
		}
		
		// Disable automatic pausing
		override protected function onFocusLost(event:Event=null):void {}
	}
}
