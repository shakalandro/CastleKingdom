package
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	public class ActiveState extends GameState
	{	
		public static const UPGRADE_MENU:String = "upgrade";
		public static const ATTACK_MENU:String = "attack";
		public static const DEFEND_MENU:String = "defend";
		
		/**
		 * A reference to the singleton castle object.
		 */		
		private var _castle:Castle;
		
		private var _towers:FlxGroup;
		
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
		 * Adds the given unit to the tilemap if possible and handles any side effects that need to take place.
		 *  
		 * @param tower Which tower to add to the tilemap
		 * @param place Where to add the tile
		 * @return Whether placing the tower was successful. This could fail if the given place is not open.
		 * 
		 */				
		public function addDefenseUnit(tower:DefenseUnit, place:FlxPoint):Boolean {
			return false;
		}
		
		public function addUnit(unit:FlxObject, x:int, y:int):void {
			_units.add(unit);
			if (FlxG.height < y && FlxG.width < x) {
				var indices:FlxPoint = cartesianToIndex(new FlxPoint(x, y));
				var tileType:int = map.getTile(indices.x, indices.y);
				if (placeable(tileType, x, y)) {
					_units.add(unit);
				}
			}
		}
		
		private static function placeable(tileType:int, x:int, y:int):Boolean {
			if (tileType >= map.collideIndex) {
				return false;
			}
			for (var obj:FlxObject in map.members) {
				var indices:FlxPoint = cartesianToIndex(new FlxPoint(obj.x, obj.y));
				if (indices.x == x && indices.y == y) {
					return false;
				}
			}
			return true;
		}
	}
}