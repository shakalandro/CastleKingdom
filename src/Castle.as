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
		public static const ACID_TRIP_MODE:Boolean = false;
		
		public static const ARMY:String = "barracks";  // stores index of barracks level in _upgrades
		public static const TOWER:String = "foundry"; // stores index of foundry level in _upgrades
		public static const UNIT_INFO:Array = new Array();// stores all unit information 
				// Tower/Unit --> ID --> info

		public static const TILE_WIDTH:int = 8;
		
		private var _upgrades:Array;  // should be:  {Castle level, Barracks level, foundry level, Smith level?}
		private var _gold:int;	
		
		private var _unitCap:int;	
				
		private var _towerCap:int;
		
		private var _leasedInNumber:int;
		private var _leasedOutNumber:int;
		private var _netWorth:int;
		
		private var _availableArmies:Array;			// all unitIDs unlocked up to upgrade level
		private var _availableTowers:Array; 		// all towerIDs unlocked up to upgrade level
		
		private var _loadedInfo:int = 0;
		
		public function Castle(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			//TODO: implement function
			super(X, Y, SimpleGraphic);

			UNIT_INFO[Castle.ARMY] = new Array();
			UNIT_INFO[Castle.TOWER] = new Array();
	
			//_upgrades = ;
	//		Database.getUserInfo(initUserInfo, FaceBook.uid);
			Database.getUserUpgrades(initUpgrades,FaceBook.uid);
			Database.getDefenseUnitInfo(initDefense); 
			Database.getEnemyInfo(initArmy);
			
			_unitCap = 100;
			_towerCap = 100;
			solid = true;
			immovable = true;
			_upgrades = new Array();
			
		}
		
		/** Adds the given upgrade to the castle**/
		private function initUserInfo(info:Array):void {
			 _gold = info[0].gold;
			 
			 continueSetup();
			 
			 
		}
		
		private function initArmy(info:Array):void {
			UNIT_INFO[Castle.ARMY]["byLevel"] = new Array();
			trace("army info size: " + info.length + " : " + info);
			for each (var obj:Object in info) {
				var ui:Array = new Array();
				ui["uid"] = obj.id.toString();
				ui["name"] = obj.name.toString();
				ui["level"] = obj.level.toString();
				ui["unitCost"] = obj.unitCost.toString();
				ui["goldCost"] = obj.goldCost.toString();
				ui["maxHealth"] = obj.maxHealth.toString();
				ui["range"] = obj.range.toString();
				ui["damage"] = obj.damage.toString();
				ui["rate"] = obj.rate.toString();
				ui["reward"] = obj.reward.toString();
				ui["move"] = obj.move.toString();
				ui["type"] = obj.type.toString();
				ui["clas"] = obj.clas.toString();
				UNIT_INFO[Castle.ARMY][obj.id] = ui;
				if(UNIT_INFO[Castle.ARMY]["byLevel"][obj.level] == null) {
					UNIT_INFO[Castle.ARMY]["byLevel"][obj.level] = new Array();
				}
				UNIT_INFO[Castle.ARMY]["byLevel"][obj.level].push(ui);
				
			}
			trace(UNIT_INFO);
			trace(UNIT_INFO[ARMY]);
			continueSetup();
		}
		
		private function continueSetup():void {
			_loadedInfo++;
			if (_loadedInfo >= 4) {
				
			}
		}
		
		private function initDefense(info:Array):void {
			UNIT_INFO[Castle.TOWER]["byLevel"] = new Array();
			for each (var obj:Object in info) {
				var ui:Array = new Array();
				ui["uid"] = obj.id.toString();
				ui["name"] = obj.name.toString();
				ui["level"] = obj.level.toString();
				ui["unitCost"] = obj.unitCost.toString();
				ui["maxHealth"] = obj.maxHealth.toString();
				ui["range"] = obj.range.toString();
				ui["damage"] = obj.damage.toString();
				ui["rate"] = obj.rate.toString();
				ui["type"] = obj.type.toString();
				ui["clas"] = obj.clas.toString();
				UNIT_INFO[Castle.TOWER][obj.id] = ui;
				if(UNIT_INFO[Castle.TOWER]["byLevel"][obj.level] == null) {
					UNIT_INFO[Castle.TOWER]["byLevel"][obj.level] = new Array();
				}
				UNIT_INFO[Castle.TOWER]["byLevel"][obj.level].push(ui);
				
			}
			continueSetup();

		}
		
		private function initUpgrades(info:Array):void {
			for each (var obj:Object in info) {
				if(obj.cid != "") {
					_upgrades["castle"]++;
					Database.getCastleInfo(initGenericPieces,obj.cid);
				} else if (obj.bid != "") {
					_upgrades["barracks"]++;
					Database.getCastleInfo(initBarracksPieces,obj.bid);
				} else if (obj.fid != "") {
					_upgrades["foundry"]++;
					Database.getCastleInfo(initFoundryPieces,obj.fid);
				} else if (obj.mid != "") {
					_upgrades["mine"]++;
					Database.getCastleInfo(initGenericPieces,obj.mid);
				} else if (obj.aid != "") {
					_upgrades["aviary"]++;
					Database.getCastleInfo(initGenericPieces,obj.aid);
				}
				continueSetup();

			}
		}
		
		private function initGenericPieces(info:Array):void {
			_towerCap += info[0].unitWorth;
			_unitCap += info[0].unitWorth;
			_netWorth += info[0].goldCost;

		}
		
		private function initBarracksPieces(info:Array):void {
			_unitCap += info[0].unitWorth;
			_netWorth += info[0].goldCost;
		}
		private function initFoundryPieces(info:Array):void {
			_towerCap += info[0].unitWorth;
			_netWorth += info[0].goldCost;
	
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
			if(amount > 0 && (amount > 0 && amount + _gold < 0)) { // handle overflow
				_gold = int.MAX_VALUE; // Caps gold at largest amount;
				return true;
			}
			if (_gold + amount < 0) {
				return false;
			}
			_gold += amount;
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
		public function unitsUnlocked(unitType:String, highest:Boolean = false):Array {
			
			// Sets to level of barracks/foundry (max if highest is true)
			var typeLevel:int = _upgrades[unitType];
			if (highest) {
				if(unitType == Castle.ARMY) {
					typeLevel = Math.max(typeLevel,_upgrades[Castle.TOWER]);
				} else {
					typeLevel = Math.max(typeLevel,_upgrades[Castle.ARMY]);
				}
			}
			typeLevel = 5;
			trace(UNIT_INFO.length);
			trace(unitType + " " + UNIT_INFO[unitType]);
			// Iterates over upgrade list to add all unitIDs contained
			var unitList:Array = new Array();
			var upgradeLevel:int = 1;
			for (; upgradeLevel <= typeLevel ; upgradeLevel++) {
				if (UNIT_INFO[unitType].byLevel[upgradeLevel] != null) {
					for(var unitID:Object in UNIT_INFO[unitType].byLevel[upgradeLevel]) {
						unitList.push(UNIT_INFO[unitType].byLevel[upgradeLevel][unitID].uid);	
					}
				}
			}
			trace("hi");
			trace(unitList.length);
			return unitList;
		}
		
		public function isGameOver():Boolean {
			return _gameOver;
		}
		
		
		public function hitRanged(Contact:FlxObject):void {
			if (Contact is EnemyUnit) {
				_gameOver = true;
			}	
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
		
		
		public function contactWithEnemy():void {
			
			_gameOver = true;
		}
		
		override public function update():void {
			if(Castle.ACID_TRIP_MODE) {
				if(Math.random() > .9) {
					this.color =  Math.random() * 0xffffffff;
				}
				
			}
			super.update();
		}
	
	}
}
