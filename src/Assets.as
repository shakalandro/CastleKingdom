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
	 */
	public class Assets
	{
		
		public static const SKIN_NORMAL:String = "normal";
		public static const SKIN_BUNNY:String = "bunny";
		private var _assets:Dictionary;
		
		// Embed all resources here
		
		// Images
		
		[Embed(source = "../images/playfield_tiles.png")]
		private static var tilesImg_normal:Class;
		public static const MAP_TILES:String = "tiles";
		
		[Embed(source = "../images/swordsman.png")]
		private static var swordsman_normal:Class;
		public static const SWORDSMAN:String = "swordsman";
		
		[Embed(source = "../images/hud_header.png")]
		private static var hud_header:Class;
		public static const HUD_HEADER:String = "hud_header";
		
		[Embed(source = "../images/menu_bg.png")]
		private static var menu_bg:Class;
		public static const MENU_BG:String = "menu_bg";
		
		[Embed(source = "../images/castle.png")]
		private static var castle_img:Class;
		public static const CASTLE:String = "castle";
		
		[Embed(source = "../images/cursor.png")]
		private static var cursor_img:Class;
		public static const CURSOR:String = "cursor";
		
		// Other resources
		
		[Embed(source = "mapLayout.txt", mimeType = "application/octet-stream")]
		private static var tileLayout_normal:Class;
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
			_normal[Assets.HUD_HEADER] = hud_header;
			_normal[Assets.MENU_BG] = menu_bg;
			_normal[Assets.CASTLE] = castle_img;
			_normal[Assets.CURSOR] = cursor_img;
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