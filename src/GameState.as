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
			
		private var _hud:FlxGroup;
		
		private var _header:FlxSprite;
		
		private var _background:FlxSprite;
		
		private var _loading:FlxSprite;
		
		private static var _cursor:AnimatedCursor;
				
		/**
		 * Constructs a new GameState. This is a helper superclass state. All persistent gamestate materials are held here. 
		 * @param tutorial
		 * @param menusActive
		 * 
		 */		
		public function GameState(map:FlxTilemap = null) {
			super();
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
			
			_cursor = new AnimatedCursor(Util.assets[Assets.CURSOR]);
			add(_cursor);
			
			_map = new FlxTilemap();
			_map.loadMap(new Util.assets[Assets.TILE_LAYOUT], Util.assets[Assets.MAP_TILES],CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE, FlxTilemap.OFF, 0, 0, 3);
			_map.y = _header.height;
			
			_background = new FlxSprite(0, _header.height, Util.assets[Assets.BACKGROUND]);
			_background.allowCollisions = FlxObject.NONE;
			_background.immovable = true;
			
			add(_background);
			add(_map);
		}
		
		public static function get cursor():AnimatedCursor {
			return _cursor;
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
		
		public function set loading(t:Boolean):void {
			_loading.visible = t; 
		}
		
		/**
		 * Draws the HUD basics that are persistent throughout states. 
		 * When overriding this function, simply add any additial UI components to hud instead of to the stage.
		 * 
		 */		
		protected function createHUD():void {
			_hud = new FlxGroup();
			_header = new FlxSprite(0, 0, Util.assets[Assets.HUD_HEADER]);
			_header.drawLine(0, _header.height, _header.width, _header.height, FlxG.BLACK, 4);
			_hud.add(_header);
			
			_loading = new FlxSprite(500, 20);
			_loading.loadGraphic(Util.assets[Assets.LOADER], true	, false, 30, 30);
			_loading.addAnimation("load", [0, 1, 2, 3, 4, 5, 6, 7], 8, true);
			_loading.play("load");
			Util.centerY(_loading, _header);
			_loading.x = Util.maxX - 100;
			
			_hud.add(_loading);
			add(_hud);
		}
	}
}
