package
{
	import org.flixel.*;
	import org.flixel.system.FlxDebugger;
	
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
		
		private var _header:FlxSprite;
				
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
			FlxG.bgColor = 0xffffffff;
		}
		
		/**
		 * Establishes persistent UI components.
		 */
		override public function create():void {
			super.create();
			createHUD();
			
			_map = new FlxTilemap();
			_map.loadMap(new Util.assets[Assets.TILE_LAYOUT], Util.assets[Assets.MAP_TILES],CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE, FlxTilemap.OFF, 0, 0, 1);
			_map.y = _header.height;
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
		 * 
		 * @return The main banner of the HUD. Nothing in the HUD should exceed the dimensions of this.
		 * 
		 */		
		public function get header():FlxSprite {
			return _header;
		}
		
		/**
		 * Pauses the game 
		 * 
		 */		
		public function pause():void {
			Util.log("paused");
			FlxG.paused = true;
			FlxG.framerate = CastleKingdom.FRAMERATE_PAUSED;
		}
		
		/**
		 * Unpauses the game 
		 * 
		 */		
		public function unpause():void {
			Util.log("unpaused");
			FlxG.paused = false;
			FlxG.framerate = CastleKingdom.FRAMERATE;
		}
		
		/**
		 * Draws the HUD basics that are persistent throughout states. 
		 * When overriding this function, simply add any additial UI components to hud instead of to the stage.
		 * 
		 */		
		protected function createHUD():void {
			_hud = new FlxGroup();
			_header = new FlxSprite(0, 0, Util.assets[Assets.HUD_HEADER]);
			_header.drawLine(0, _header.height - 3, _header.width, _header.height - 3, FlxG.BLACK, 4);
			_hud.add(_header);
			add(_hud);
		}
	}
}