/** Team AWESOME, 4/19/2011
 * 
 * Castle class
 * 
 * Information: 	User's gold and upgrade levels
 * Functionality:	Get gold balance, 
 * 					get upgrade levels, 
 * 					get army /tower cap, 
 * 					get remaining available army/ tower units, 
 * 					get current leased ammount 	
 * Display:			Shows a predetermined castle image based on upgrade levels to each item 
 * 
 * @field _upgrades:Array 	List of all upgrades user has bought, should be integers. 
 * @field _gold:int 		Balance of gold user has, must be &gt;= 0
 * @field _unitCap:int		Total army unit number supported
 * @field _towerCap:int 	Total tower unit number supported
 * @field
 */

package
{
	import org.flixel.*;
	
	public class Castle extends FlxSprite
	{
		
		private var _gameOver:Boolean = false;
		
		public static const ARMY:int = 0;  // stores index of barracks level in _upgrades
		public static const TOWER:int = 1; // stores index of foundry level in _upgrades
		
		private var _upgrades:Array;  // should be:  {Castle level, Barracks level, foundry level, Smith level?}
		private var _gold:int;	
		
		private var _unitCap:int;	
				
		private var _towerCap:int;
		
		private var _leasedInNumber:int;
		private var _leasedOutNumber:int;
		
		private var _availableArmies:Array;			// all unitIDs unlocked up to upgrade level
		private var _availableTowers:Array; 		// all towerIDs unlocked up to upgrade level
		
		
		public function Castle(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			//TODO: implement function
			super(X, Y, SimpleGraphic);
			//_upgrades = ;
			
			_unitCap = 40;
			_towerCap = 40;
			solid = true;
			immovable = true;
		}
		
		/** Adds the given upgrade to the castle
		 * */
		public function setUpgrade(upgradeid:int):void {
			
		}
		
		/** Returns the player's unit capacity as a function of the purchased upgrades and acheivements
		 * */
		public function get unitCapacity():int {
			return _unitCap;
		}
		
		/** Returns how many army units the player has to use
		 * */
		public function get armyUnitsAvailable():int {
			return _unitCap - unitCostSum((FlxG.state as ActiveState).units);
		}
		
		public function get towerCapacity():int {
			return _towerCap;
		}
		
		// Returns how many tower units the player has to use
		public function get towerUnitsAvailable():int {
			return _towerCap - unitCostSum((FlxG.state as ActiveState).towers);
		}
		
		public function get gold():int {
			return _gold;
		}
		
		/**
		 * 
		 * @param amount - +/- amount to add to gold supply
		 * @return true if this is a valid change and was completed or capped
		 * 			false if the sum brought the value below 0
		 * 
		 */		
		public function addGold(amount:int):Boolean {
			if(amount > 0 && amount + _gold < 0) { // handle overflow
				_gold = int.MAX_VALUE; // Caps gold at largest amount;
				return true;
			}
			_gold += amount;
			if (_gold < 0) {
				_gold += amount;
				return false;
			}
			return true;
		}
		
		// Returns an array of what towerIDs are available for use 
		// based on upgrades and achivements. This array shoud be sorted first
		public function availableTowers():Array {
			return null;
		}
		
		// Returns whether the player is leasing units from anyone
		public function get isLeasing():Boolean {
			return _leasedInNumber > 0;
		}
		
		// Returns whether the player is leasing units from anyone
		public function get isLeased():Boolean {
			return _leasedOutNumber > 0;
		}
		
		// Should unlease all leased units
		// This should be done with only a database update, a second lookup shouldnot be necessary
		public function unlease():void {
			_leasedOutNumber = 0;
			// call database update function to set leasing to false;
			
		}
		
		public function leaseOut(user:String, number:int):void {
			
			// call to util function
			
		}
		
		
		
		private function unitCostSum(unitList:FlxGroup):int {
			var cost:int = 0;
			for each (var unit:Unit in unitList) {
				cost += unit.cost; 
			}
			return cost;
		}
		
		/** Returns the unit numbers for the units unlocked by the castle's upgrade levels
		 * 
		 * @param unitType Either Castle.TOWER or Castle.ARMY to search for each type
		 * @return 
		 * 
		 */		
		public function unitsUnlocked(unitType:int, highest:Boolean = false):Array {
			var typeLevel:int = 0; //_upgrades[unitType];
			if (highest) {
				if(unitType == Castle.ARMY) {
			//		typeLevel = Math.max(typeLevel,_upgrades[Castle.TOWER]);
				} else {
			//		typeLevel = Math.max(typeLevel,_upgrades[Castle.ARMY]);
				}
			}
			// Iterates over upgrade list to add all unitIDs contained
			var unitList:Array = new Array();
			for (var upgradeLevel:int = 0; upgradeLevel <= typeLevel ; upgradeLevel++) {
				//for(var unitID in unlockables[unitType][upgradeLevel]) {
				//	unitList.push(unitID);	
				//}
			}
			unitList.push(10101); // Test soldier
			return unitList;
		}
		
		public function isGameOver():Boolean {
			return _gameOver;
		}
		
		
		/** If castle is hit by EnemyUnit, game is over.
		 * */
		public function hitRight(Contact:FlxObject, Velocity:Number):void {		
			if (Contact is EnemyUnit) {
				_gameOver = true;
			}	
		}
		
		public function hitLeft(Contact:FlxObject, Velocity:Number):void {
			if (Contact is EnemyUnit) {
				_gameOver = true;
			}	
		}
		public function hitTop(Contact:FlxObject, Velocity:Number):void {
			if (Contact is EnemyUnit) {
				_gameOver = true;
			}	
		}
		
		public function hitBottom(Contact:FlxObject, Velocity:Number):void {
			if (Contact is EnemyUnit) {
				_gameOver = true
			}	
		}
		
		
		public function contactWithEnemy() {
			
			_gameOver = true;
		}
		
	
	}
}
