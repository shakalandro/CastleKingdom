package
{
	import flash.utils.Dictionary;
	
	import org.flixel.FlxSprite;
	
	/**
	 * This class keeps track of different dictionaries filled with assets for Castle 
	 * Kingdom (attack units, defense units, castle upgrades) that pertain to different
	 * skins. The overall dictionary is a map from String (skin name) to a dictionary
	 * for the assets for that skin. The containing dictionaries are maps from
	 * Strings to objects. 
	 * 
	 * @author Kimmy Win, Roy McElmurry
	 * Kim is a pretty pretty princess
	 */
	public class Assets
	{
		
		public static const SKIN_NORMAL:String = "normal";
		public static const SKIN_BUNNY:String = "bunny";
		private var _assets:Dictionary;
		
		// Embed all resources here
		
		[Embed(source = "../images/test_tile.png")]
		private var tilesImg_normal:Class;
		public static const MAP_TILES:String = "tiles";
		
		[Embed(source = "../images/swordsman.png")]
		private var swordsman_normal:Class;
		public static const SWORDSMAN:String = "swordsman";
		
		[Embed(source = "mapLayout.txt", mimeType = "application/octet-stream")]
		private var tileLayout_normal:Class;
		public static const TILE_LAYOUT:String = "tileLayout";
		
		// End resource embed area
		
		/**
		 * Create the dictionaries of assets
		 * 
		 */
		public function Assets(){
			_assets = new Dictionary();
			
			var _bunny:Dictionary = new Dictionary();
			var _normal:Dictionary = new Dictionary();
			
			_assets[SKIN_BUNNY] = _bunny;
			_assets[SKIN_NORMAL] = _normal;
			
			_normal[Assets.MAP_TILES] = tilesImg_normal;
			_normal[Assets.SWORDSMAN] = swordsman_normal;
			_normal[Assets.TILE_LAYOUT] = tileLayout_normal;
			
		}
		
		/**
		 * Gives access to the assets dictioanry of resources.
		 * 
]		 * @return A dictionary from skin strings to dictionaries from resource name to resource.
		 * 
		 */
		public function get assets():Dictionary{
			return _assets;
		}
	}
}