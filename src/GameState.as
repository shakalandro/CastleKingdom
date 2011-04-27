package
{
	import org.flixel.*;
	
	/**
	 * This is a base class for all game states. This class sets up some of the basic functionality of our state and draws the persistent HUD components. 
	 * @author royman
	 * 
	 */	
	public class GameState extends FlxState
	{	
		/**
		 * The tilemap of game pieces. 
		 */		
		private var _map:FlxTilemap;
		
		private var _tutorial:Boolean;
		
		private var _menusActive:Boolean;
		
		private var _hud:FlxGroup;
		
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
			super.create();
			createHUD();
			
			_map = new FlxTilemap();
			_map.drawIndex = 0;
			_map.collideIndex = 1;
			_map.loadMap(new Util.assets[Assets.TILE_LAYOUT], Util.assets[Assets.MAP_TILES], CastleKingdom.TILE_SIZE);
			_map.y = _hud.height;
			add(_map);
		}
		
		/**
		 * Updates GamesState's state every game loop tick
		 */
		override public function update():void {
			super.update();	
		}
		
		/**
		 * @return The tilemap of game pieces. 
		 */		
		public function get map():FlxTilemap {
			return _map;
		}
		
		/**
		 * 
		 * @return The HUD sprite.
		 * 
		 */		
		public function get hud():FlxGroup {
			return _hud;
		}
		
		/**
		 * Draws the HUD basics that are persistent throughout states. 
		 * When overriding this function, simply add any additial UI components to hud instead of to the stage.
		 * 
		 */		
		protected function createHUD():void {
			_hud = new FlxGroup();
			var header:FlxSprite = new FlxSprite(0, 0, Util.assets[Assets.HUD_HEADER]);
			_hud.add(header);
			_hud.width = header.width;
			_hud.height = header.height;
			add(_hud);
		}
	}
}