package
{
	import org.flixel.*;
	import org.flixel.system.FlxWindow;
	
	/**
	 * Creates additional functionality for game states whether the player is actively involved. 
	 * Handles things like menu interaction, ranged collision detection and adding units to the map. 
	 * @author royman
	 * 
	 */	
	public class ActiveState extends GameState
	{	
		public static const UPGRADE_MENU:String = "upgrade";
		public static const ATTACK_MENU:String = "attack";
		public static const DEFEND_MENU:String = "defend";
		
		private static const HUD_BUTTON_PADDING:uint = 10;
		
		/**
		 * A reference to the singleton castle object.
		 */		
		private var _castle:Castle;
		
		/**
		 * A group of DefenseUnits 
		 */		
		private var _towers:FlxGroup;
		
		/**
		 * A group of EnemyUnits 
		 */		
		private var _units:FlxGroup;
		
		private var _openMenu:FlxBasic;
		
		
		/** FlxSprites for unit caps/gold;
		 * 
		 * */
		private var _goldDisplay:FlxText;
		private var _towerDisplay:FlxText;
		private var _armyDisplay:FlxText;
		
		/** 
		 * An active state is a helper super class for interactive game states such as DefendState and UpgradeState. 
		 * Maintains the tilemap and a reference to the castle object. Performs ranged collision calculation.
		 * 
		 * @param tutorial Whether the state should display tutorial information and UI components.
		 * @param menusActive Whether the menu buttons are active
		 * 
		 */		
		public function ActiveState(tutorial:Boolean = false, menusActive:Boolean = false, map:FlxTilemap = null)
		{
			super(tutorial, menusActive, map);
			_towers = new FlxGroup();
			_units = new FlxGroup();
		}
		
		/**
		 * Sets up the Tilemap based on the information in FlxSave or the Database
		 * Draws tutorial UI components if tutorial is true. Draws the menu buttons on the screen.
		 * 
		 */		
		override public function create():void {
			super.create();
			add(_towers);
			add(_units);
			_castle = new Castle(0, 0, Util.assets[Assets.CASTLE]);
			Util.centerX(_castle);
			Util.placeOnGround(_castle, map);
			add(_castle);
			if (CastleKingdom.FACEBOOK_ON) {
				FaceBook.picture(function(pic:Class):void {
					var profilePic:FlxSprite = new FlxSprite(0, 0, pic);
					Util.center(profilePic, header);
					profilePic.x = Util.maxX - profilePic.width;
					hud.add(profilePic);
				}, "me", false, "small");
			}
		
		}
		
		/**
		 * In addition to normal collision detection, detects collisions between units with ranges. 
		 * If a unit does have a ranged collisions, the unit's hitRanged method is called.
		 * The object that the unit collided with is passed as the first parameter to hitRanged.
		 * <ul>
		 * 		<li>ex) an archer moves within its range of a wall</li>
		 * 		<li>ex) an arrow tower has a guy come within its range</li>
		 * </ul>
		 * 
		 */		
		public function collide():void {
			FlxG.collide();
		}
		
		/**
		 * 
		 * @return The singleton castle object
		 * 
		 */		
		public function get castle():Castle {
			return _castle;
		}
		
		/**
		 * 
		 * @return The FlxGroup of units.
		 * 
		 */		
		public function get units():FlxGroup {
			return _units;
		}
		
		/**
		 * 
		 * @return The FlxGroup of towers.
		 * 
		 */		
		public function get towers():FlxGroup {
			return _towers;
		}
		
		/**
		 * This should respond by drawing the given enabled menu on screen. Best called using the constants ActiveState.ATTACK_MENU, etc.
		 * 
		 * @param menu Which menu to draw.
		 * 
		 */		 
		public function showMenu(menu:String):void {
			if (_openMenu != null) {
				_openMenu.kill();	
			}
			pause();
			if (menu == ActiveState.DEFEND_MENU) {
				Database.getTowerUnits(function(towers:Array):void {
					var group:FlxGroup = new FlxGroup();
					for (var i:int = 0; i < towers.length; i++) {
						var towerStats:Object = towers[i];
						group.add(new FlxSprite(i * 20 % CastleKingdom.WIDTH / 2, i * 20 / (CastleKingdom.WIDTH / 2), Util.assets[Assets.SWORDSMAN]));
					}
					_openMenu = Util.window(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, group, unpause, menu, 0xffffffff, 10, 
						CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2);
				});
			} else {
				_openMenu = Util.window(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, null, unpause, menu, 0xffffffff, 10, 
					CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2);
			}
			add(_openMenu);
		}
		
		/**
		 * Adds the given DefenseUnit to the display list at the closest tile indices (rounded down) if possible. 
		 *  
		 * @param tower Which tower to add to the tilemap
		 * @param place Where to add the tile
		 * @return Whether placing the tower was successful. This could fail if the given place is not open.
		 * 
		 */				
		public function addDefenseUnit(tower:DefenseUnit, x:Number, y:Number):Boolean {
			return addUnit(_towers, tower, x, y);
		}
		
		/**
		 * Adds the given EnemyUnit to the display list at the closest tile indices (rounded down) if possible.
		 * 
		 * @param unit The unit being added.
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return Whether the given unit was able to be placed.
		 * 
		 */	
		public function addEnemyUnit(enemy:EnemyUnit, x:Number, y:Number):Boolean {				
			return addUnit(_units, enemy, x, y);
		}
		
		/**
		 * Adds the given Unit to the given group at the closest tile indices (rounded down) if possible.
		 * 
		 * @param group The desired group to add to
		 * @param unit A unit to add if possible
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return 
		 * 
		 */		
		private function addUnit(group:FlxGroup, unit:Unit, x:Number, y:Number):Boolean {
			if (placeable(x, y)) {
				var coordinates:FlxPoint = Util.roundToNearestTile(new FlxPoint(x, y));
				unit.x = coordinates.x;
				unit.y = coordinates.y;
				group.add(unit);
				return true;
			}
			return false;
		}
		
		/**
		 * This method determines whether the given (x, y) coordinate is a valid place to put a tower.
		 * Checks whether the location is obstructed by a collidable tile (terrain) 
		 * or the location is already taken by an existing tower.
		 * 
		 * @param x The cartesian x coordinate being considered
		 * @param y The cartesian y coordinate being considered
		 * @return Whether a tower could be placed at (x, y)
		 * 
		 */		
		private function placeable(x:int, y:int):Boolean {
			if (!Util.inBounds(x, y)) return false;
			var indices:FlxPoint = Util.cartesianToIndices(new FlxPoint(x, y));
			var tileType:int = map.getTile(indices.x, indices.y);
			if (tileType >= map.collideIndex) {
				return false;
			}
			for each (var obj:FlxObject in _towers.members) {
				var objIndices:FlxPoint = Util.cartesianToIndices(new FlxPoint(obj.x, obj.y));
				if (objIndices.x == indices.x && objIndices.y == indices.y) {
					return false;
				}
			}
			return true;
		}
		
		override protected function createHUD():void {
			super.createHUD();
			var attack:FlxButton = new FlxButton(0, 0, "Attack", function():void {
				showMenu(ATTACK_MENU);
			});
			
			var defend:FlxButton = new FlxButton(0, 0, "Defend", function():void {
				showMenu(DEFEND_MENU);
			});
			
			var upgrade:FlxButton = new FlxButton(0, 0, "Upgrade", function():void {
				showMenu(UPGRADE_MENU);
			});
			
			attack.allowCollisions = FlxObject.NONE;
			defend.allowCollisions = FlxObject.NONE;
			upgrade.allowCollisions = FlxObject.NONE;
			
			Util.centerY(attack, header);
			Util.centerY(defend, header);
			Util.centerY(upgrade, header);
			
			upgrade.x = Util.maxX - upgrade.width - 70;
			attack.x = upgrade.x - attack.width - HUD_BUTTON_PADDING;
			defend.x = attack.x - defend.width - HUD_BUTTON_PADDING;
			Util.log(upgrade.width, attack.width, defend.width);
			
			
			//		_towerDisplay = new FlxSprite(Util.maxX-100,20);
			//		_armyDisplay = new FlxSprite(Util.maxX-100,40);
			//_goldDisplay.
			
			hud.add(attack);
			hud.add(defend);
			hud.add(upgrade);
		}
		
		override public function update():void {
			drawStats();
			
			super.update();
		}
		
		public function drawStats(startX:int = 0, startY:int = 0):void {
			hud.remove(_goldDisplay);
			_goldDisplay = new FlxText(startX,startY,100, "Gold: " + this.castle.gold);
			hud.add(_goldDisplay);
			
			hud.remove(_armyDisplay);
			
			_armyDisplay = new FlxText(startX,startY+10,100, 
				this.castle.unitCapacity - this.castle.armyUnitsAvailable + " of " + this.castle.unitCapacity + " Armies");
			
			hud.add(_armyDisplay);
			
			hud.remove(_towerDisplay);
			_towerDisplay = new FlxText(startX,startY+20,100, 
				this.castle.towerCapacity - this.castle.towerUnitsAvailable + 
				" of " + this.castle.towerCapacity + " Towers");
			hud.add(_towerDisplay);
			
		}
	}
}
