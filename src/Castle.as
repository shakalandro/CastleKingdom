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
 * @field _gold:int 		Balance of gold user has, must be >= 0
 * @field _unitCap:int		Total army unit number supported
 * @field _towerCap:int 	Total tower unit number supported
 * @field
 */

package
{
	import org.flixel.FlxSprite;
	
	public class Castle extends FlxSprite
	{
		
		public static const ARMY:int = "1"; 
		public static const TOWER:int = "2"; 
		
		private var _upgrades:Array;  // should be:  {Castle level, Barracks level, foundry level, Smith level?}
		private var _gold:int;	
		
		private var _unitCap:int;	
		private var _army:Array;
				
		private var _towerCap:int;
		private var _towers:Array;
		
		private var _isLeased:Boolean;
		private var _leasedInNumber:int;
		private var _leasedOutNumber:int;
		
		private var _availableArmies:Array;			// all unitIDs unlocked up to upgrade level
		private var _availableTowers:Array; 		// all towerIDs unlocked up to upgrade level
		
		
		public function Castle(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			//TODO: implement function
			super(X, Y, SimpleGraphic);
		}
		

		/** Looks up all the upgrades that have been 
		 * purchased and configures them on screen
		 */
		override public function create(username:String):void {
			// Call utility function to get list of upgrades, if has leased values, 
			
			// Display image
		}
		
		//Adds the given upgrade to the castle
		public function setUpgrade(upgradeid:int):void
		
		// Returns the player's unit capacity as a function of the purchased upgrades and acheivements
		public function unitCapacity():int {
			return unitCap;
		}
		
		// Returns how many army units the player has to use
		public function armyUnitsAvailabe():int {
			return unitCap - unitSum(_army);
		}
		
		// Returns how many tower units the player has to use
		public function towerUnitsAvailabe():int {
			return unitCap - unitCostSum(_army);
		}
		
		// Returns an array of what towerIDs are available for use 
		// based on upgrades and achivements. This array shoud be sorted first
		public function availableTowers():Array {
			
			
		
		}
		
		// Returns whether the player is leasing units from anyone
		public function isLeasing():Boolean {
			return _leasedInNumber > 0;
		}
		
		// Returns whether the player is leasing units from anyone
		public function isLeased():Boolean {
			return _leasedOutNumber > 0;
		}
		
		// Should unlease all leased units
		// This should be done with only a database update, a second lookup shouldnot be necessary
		public function unlease():void {
			_leasedOutNumber = 0;
			// call database update function to set leasing to false;
			
		}
		
		public function leaseOut(var user:String, var number:int):void {
			
			// call to util function
			
		}
		
		
		
		private function unitCostSum(var unitList:Array):int {
			var cost:int = 0;
			for (var unit in unitList) {
				cost += unit.getCost(); 
			}
		}
		
		private function unitsUnlocked(var unitType:int):Array {
			// Iterates over upgrade list to add all unitIDs contained
			var unitList:Array = new Array();
			for (var upgradeLevel = 0; upgradeLevel <= _upgrades[unitType]; upgradeLevel++) {
				for(var unitID in unlockables[unitType][upgradeLevel]) {
					unitList.push(unitID);	
				}
			}
		}
		
	}
}