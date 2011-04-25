package
{
	import org.flixel.*;
	
	[SWF(width="828", height="414", backgroundColor="#ffffff")]
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
		
		public function CastleKingdom()
		{
			super(828, 414, null, 1);
		}
	}
}