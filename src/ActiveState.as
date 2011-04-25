package
{
	import org.flixel.*;
	
	public class ActiveState extends GameState
	{	
		public static const UPGRADE_MENU:String = "upgrade";
		public static const ATTACK_MENU:String = "attack";
		public static const DEFEND_MENU:String = "defend";
		
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
		override public function collide():void {
			super.collide();
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
				// Need to get rounded index numbers, add functionality to Util
				var indices:FlxPoint = Util.cartesianToIndexes(new FlxPoint(x, y));
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
			if (0 < y || FlxG.height > y || 0 < x || FlxG.width > x) {
				return false;	
			}
			var indices:FlxPoint = Util.cartesianToIndexes(new FlxPoint(x, y));
			var tileType:int = map.getTile(indices.x, indices.y);
			if (tileType >= map.collideIndex) {
				return false;
			}
			for each (var obj:FlxObject in _towers.members) {
				var objIndices:FlxPoint = Util.cartesianToIndexes(new FlxPoint(obj.x, obj.y));
				if (objIndices.x == indices.x && objIndices.y == indices.y) {
					return false;
				}
			}
			return true;
		}
	}
}