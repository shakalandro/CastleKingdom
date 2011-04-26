package
{
	import org.flixel.*;
	
	public class GameState extends FlxState
	{	
		/**
		 * The tilemap of game pieces. 
		 */		
		private var _map:FlxTilemap;
		
		private var _tutorial:Boolean;
		
		private var _menusActive:Boolean;
		
		/**
		 * Constructs a new GameState. This is a helper superclass state. All persistent gamestate materials are held here. 
		 * @param tutorial
		 * @param menusActive
		 * 
		 */		
		public function GameState(tutorial:Boolean = false, menusActive:Boolean = false, map:FlxTilemap = null) {
			super();
			_tutorial = tutorial;
			_menusActive = menusActive;
			if (map == null) map = new FlxTilemap();
			_map = map;
			bgColor = 0xffffffff;
		}
		
		/**
		 * Establishes persistent UI components.
		 */
		override public function create():void {
			_map = new FlxTilemap();
			_map.drawIndex = 0;
			_map.collideIndex = 1;
			_map.loadMap(new Util.assets[Assets.TILE_LAYOUT], Util.assets[Assets.MAP_TILES], CastleKingdom.TILE_SIZE);
			add(_map);
			
			createHUD();
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
		
		private function createHUD():void {
			//TODO: should use an image as the third parameter
			var navBar:FlxSprite = new FlxSprite(0, 0);
			navBar.fill(0xdd888888);
			add(navBar);
		}
	}
}