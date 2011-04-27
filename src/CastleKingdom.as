package
{	
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
		public static const TILEMAP_WIDTH:int = 36;
		public static const TILEMAP_HEIGHT:int = 18;
		public static const TILE_SIZE:int = 23;
		public static const SKIN:String = Assets.SKIN_NORMAL;
				
		public function CastleKingdom()
		{
			super(828, 460, LoginState, 1);
			FlxG.mouse.show(Util.assets[Assets.CURSOR]);
		}
	}
}