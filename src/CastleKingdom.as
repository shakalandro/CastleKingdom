package
{
	import com.facebook.graph.*;
	
	import flash.text.TextField;
	
	import org.flixel.*;
	import org.flixel.data.FlxMouse;
	
	[SWF(width="828", height="460", backgroundColor="#ffffff")]
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
		private static const FACEBOOK_APP_ID:String = "197220693652461";
		private static const FACEBOOK_SECRET_KEY:String = "592b9006282d5442f9d042b56fe04913";
		
		public static const TILEMAP_WIDTH:int = 36;
		public static const TILEMAP_HEIGHT:int = 18;
		public static const TILE_SIZE:int = 23;
		public static const SKIN:String = Assets.SKIN_NORMAL;
		
		private static var _log:TextField = new TextField();
		
		public function CastleKingdom()
		{
			super(828, 460, ActiveState, 1);
			FlxG.mouse.show(Util.assets[Assets.CURSOR]);
			
			Facebook.init(CastleKingdom.FACEBOOK_APP_ID, function(success:Object, fail:Object):void {
				trace("initialized: " + fail);
				CastleKingdom.log("initialized" + success);
			});
			trace("done");
			
			_log.x = 0;
			_log.y = FlxG.height - 20;
			_log.width = FlxG.width;
			this.addChild(_log);
		}
		
		public static function log(s:String):void {
			_log.text = s;
		}
	}
}