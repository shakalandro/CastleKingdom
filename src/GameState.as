package
{
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class GameState extends FlxState
	{
		
		[Embed(source = "../images/test_tile.png")]
		private var tilesImg:Class;
		
		[Embed(source = "mapLayout.txt")]
		private var tileLayout:Class;
		
		/**
		 * The tilemap of game pieces. 
		 */		
		private var _map:FlxTilemap;
		
		public function GameState() {
			this(false, false);
		}
		
		/**
		 * Constructs a new GameState. This is a helper superclass state All persistent gamestate materials are held here. 
		 * @param tutorial
		 * @param menusActive
		 * 
		 */		
		public function GameState(tutorial:Boolean, menusActive:Boolean, map:FlxTilemap = null) {
			if (map == null) map = new FlxTilemap();
			map.loadMap(new tileLayout, tilesImg, CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE);
		}
		
		/**
		 * Establishes persistent UI components.
		 */
		override public function create():void {
			//super.create();
			add(map);
		}
		
		/**
		 * Updates GamesState's state every game loop tick
		 */
		override public function update():void {
			super.update();
		}
		
		/**
		 * The tilemap of game pieces. 
		 */		
		public function get map():FlxTilemap {
			return _map;
		}
	}
}