package
{
	import org.flixel.*;
	
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
	 * @author Justin
	 */
	public class Castle extends FlxSprite
	{
		public static const TUTORIAL_UPGRADES_NEEDED:int = 3;

		public static const TUTORIAL_NEW_USER:int = 0;
		public static const TUTORIAL_FIRST_DEFEND:int = 1;
		public static const TUTORIAL_FIRST_WAVE:int = 2;
		public static const TUTORIAL_UPGRADE:int = 3;
		public static const TUTORIAL_ATTACK_FRIENDS:int = 4;
		public static const TUTORIAL_LEASE:int = 5;
		
		private var _gameOver:Boolean = false;
		public static const ACID_TRIP_MODE:Boolean = false;
		
		public static const ARMY:String = "barracks";  // stores index of barracks level in _upgrades
		public static const TOWER:String = "foundry"; // stores index of foundry level in _upgrades
		public static const UNIT_INFO:Array = new Array();// stores all unit information 
				// Tower/Unit --> ID --> info
		public static const UPGRADE_INFO:Array = new Array();

		public static const TILE_WIDTH:int = 8;
		public static const START_GOLD:Number = 0;
		public static const START_TOWER_CAPACITY:Number = 60;
		public static const START_UNIT_CAPACITY:Number = 60;
		
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
		private static var _tutorialLevel:int;
		private var _attackSeed:Number;
		private var _UpgrImages:FlxGroup;
		private var _blingbling:FlxSprite;
		
		private var _sessionAttackCounter:int;
		
		public function Castle(X:Number=0, Y:Number=0, SimpleGraphic:Class=null)
		{
			//TODO: implement function
			super(X, Y, SimpleGraphic);
			trace("CREATING NEW CASTLE");
			
			UNIT_INFO[Castle.ARMY] = new Array();
			UNIT_INFO[Castle.TOWER] = new Array();
			_unitCap = START_UNIT_CAPACITY;
			_towerCap = START_TOWER_CAPACITY;
			_gold = START_GOLD;
			_upgrades = new Array();
			_upgrades["barracks"] = 0;
			_upgrades["foundry"] = 0;
			_upgrades["castle"] = 0;
			_upgrades["mine"] = 0;
			_upgrades["aviary"] = 0;
			Database.getUpgradesInfo(function(info:Array):void {
				for each (var thingy:Object in info) {
					UPGRADE_INFO[thingy.id.toString()] = thingy;
				}
				Database.getUserUpgrades(initUpgrades,FaceBook.uid);
			});  // caches data (in theory)
			Database.getUserInfo(initUserInfo, FaceBook.uid);
			Database.getDefenseUnitInfo(initDefense);  // stores into UNIT_INFO
			Database.getEnemyInfo(initArmy);
			
			_attackSeed = Math.random();
			solid = true;
			immovable = true;
			_sessionAttackCounter = 0;

			
		}
		
		public function get sessionAttackCounter():int {
			return _sessionAttackCounter;
		}
		
		public function set sessionAttackCounter(x:int) {
			_sessionAttackCounter = x;
		}
		
		public function get upgrImages():FlxGroup {
			return _UpgrImages;
		}
		
		/**
		 * Meaning can be found in the numbers through the TUTORIAL_X constants
		 * @return The current tutorial level of the player.
		 * 
		 */		
		public static function get tutorialLevel():int {
			return _tutorialLevel;
		}
		
		/**
		 * 
		 * @param n Sets the current tutorial level.
		 * 
		 */		
		public static function set tutorialLevel(n:int):void {
			_tutorialLevel = n;
		}
		
		/**
		 * 
		 * @return How much gold it would take to surrender.
		 * 
		 */		
		public function surrenderCost():int {
			return Math.round(gold * .6) ;
		}
		
		public function sendWaveCost():int {
			return 100;
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
		
		public function drawUpgrades():void {
			if (_UpgrImages) {
				FlxG.state.remove(_UpgrImages);
			}
			_blingbling = new FlxSprite(x,y+this.height);
			_blingbling.loadGraphic(Util.assets["blingbling"],false,false,138,115);
			_blingbling.frame = blingFrame();
			var vaultCover:FlxSprite = new FlxSprite(x,y+this.height,Util.assets["vaultCover"]);
			vaultCover.alpha = .4;
			Util.centerX(vaultCover);
			var vaultGrass:FlxSprite = new FlxSprite(x,y+this.height,Util.assets["vaultGrass"]);
			Util.centerX(vaultGrass);
			vaultGrass.alpha = .8;
			//_blingbling.alpha = .75;
			Util.centerX(_blingbling);
			_UpgrImages = new FlxGroup(); 
			_UpgrImages.add(_blingbling);
			_UpgrImages.add(vaultCover);
			_UpgrImages.add(vaultGrass);
			applyImage("barracks");
			applyImage("foundry");
			applyImage("castle");
			applyImage("mine");
			applyImage("aviary");
			FlxG.state.add(_UpgrImages);
		}
		
		/** Called after each of 4 load methods called.
		 * When counter is 4, continues any additional loading requiring all to be finished
		 * */
		private function continueSetup():void {
			_loadedInfo++;
			if (_loadedInfo >= 4) {
				
			}
		}
		
		private function applyImage(type:String):void {
			var imgName:String = type + this._upgrades[type];
			if(Util.assets[imgName] != null) {
				var upgr:FlxSprite = new FlxSprite(this.x,this.y + this.height,Util.assets[imgName]);
				upgr.y = this.y + this.height - upgr.height;
				Util.centerX(upgr);
				this._UpgrImages.add(upgr);
			}
		}
		
		public function resetGame():void {
			this._gameOver = false;
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
				var upgr:Object = UPGRADE_INFO[obj.upid.toString()];
				var type:int = parseInt(upgr.id.toString())/1000;
				if(type == 1) {
					_upgrades["castle"] = Math.max(_upgrades["castle"], upgr.level.toString());
					initGenericPieces(upgr);
				} else if (type == 2) {
					_upgrades["barracks"] = Math.max(_upgrades["barracks"], upgr.level.toString());
					initBarracksPieces(upgr);
				} else if (type == 3) {
					_upgrades["foundry"]  = Math.max(_upgrades["foundry"], upgr.level.toString());
					initFoundryPieces(upgr);
				} else if (type == 4) {
					_upgrades["mine"] = Math.max(_upgrades["mine"], upgr.level.toString());;
					initGenericPieces(upgr);
				} else if (type == 5) {
					_upgrades["aviary"] = Math.max(_upgrades["aviary"], upgr.level.toString());;
					initGenericPieces(upgr);
				}
				

			}
			continueSetup();
			drawUpgrades();

		}
		
		private function initGenericPieces(info:Object):void {
			_towerCap += parseInt(info.unitWorth);
			_unitCap += parseInt(info.unitWorth);
			_netWorth += parseInt(info.goldCost);

		}
		
		private function initBarracksPieces(info:Object):void {
			_unitCap += parseInt(info.unitWorth);
			_netWorth += parseInt(info.goldCost);
		}
		private function initFoundryPieces(info:Object):void {
			_towerCap += parseInt(info.unitWorth);
			_netWorth += parseInt(info.goldCost);
	
		}
		
		
		/** Adds the given upgrade to the castle
		 * @return true if the user has enough money to buy it, false otherwise
		 * */
		public function setUpgrade(upgrade:Upgrade):Boolean {
			upgrade.type = upgrade.type.toLowerCase();
			if( (this.gold >= upgrade.goldCost 
					&& _upgrades[upgrade.type] == upgrade.level - 1
					&& (upgrade.type == "castle" || _upgrades["castle"] >= upgrade.level) )
					|| CastleKingdom.DEBUG) {
				this.addGold(-upgrade.goldCost);
				if (upgrade.type == "barracks") {
					 _unitCap += upgrade.unitWorth;
				} else if (upgrade.type == "foundry") {
					_towerCap += upgrade.unitWorth;
				} else {
					_unitCap += upgrade.unitWorth;
					_towerCap += upgrade.unitWorth;
	
				}
				_upgrades[upgrade.type] = upgrade.level;
				Util.log("\n\n\nBefore calling insert: \n{id: " + FaceBook.uid + ", upid: " + upgrade.upgradeID + 
					"}\n\n\n"); 
				Database.insertUserUpgrade({id:FaceBook.uid, upid:upgrade.upgradeID,xpos:0,ypos:0});
				drawUpgrades();
				return true;
			}
			return false;
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
			return _towerCap - _leasedOutNumber + _leasedInNumber;
		}
		
		/** Returns how many tower units the player has to use
		 * */
		public function get towerUnitsAvailable():int {
			return _towerCap - _leasedOutNumber + _leasedInNumber - unitCostSum((FlxG.state as ActiveState).towers);
		}
		
		/** Returns how much gold the user has */
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
		
			_gold += amount;
			if(_blingbling)	_blingbling.frame = blingFrame();
			
			if (_gold + amount < 0) {
				return false;
			}			
			Database.updateUserInfo({id:(FaceBook.uid), gold: _gold, units:this.unitCapacity + this.towerCapacity});
			return true;
		}
		
		/** returns int between 0 and 14 (max gold frames) */
		private function blingFrame():int {
			return Math.min(	14, // caps at highest frame
								Math.floor(  // round up
											Math.log( // normalize so that changes at good rate
													Math.max(1,gold/30))  )); // ensure valid, good start pattern
		}
		
		
		// Returns whether the player is leasing units from anyone
		public function get isLeasing():Boolean {
			return _leasedInNumber > 0;
		}
		
		public function set leasedOutUnits(n:Number):void {
			Util.log("leases out " + n);
			_leasedOutNumber = n;
		}
		
		public function get leasedOutUnits():Number {
			return _leasedOutNumber;
		}
		
		public function set leasedInUnits(n:Number):void {
			Util.log("leases in " + n);
			_leasedInNumber = n;
		}
		
		public function get leasedInUnits():Number {
			return _leasedInNumber;
		}
		
		// Returns whether the player is leasing units to anyone
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
		
		/**
		 * 
		 * @param ox
		 * @param oy
		 * @return 
		 * 
		 */
		public function pointIsInCastle(ox:int, oy:int):Boolean {
			var isIn:Boolean = ( ox > this.x && ox < this.x + this.width 
				&& oy > this.y && oy < this.y + this.height);
			for each (var upgr:FlxSprite in _UpgrImages.members) {
				if(( ox > upgr.x && ox < upgr.x + upgr.width 
					&& oy > upgr.y && oy < upgr.y + upgr.height)) {
					isIn = true;
				}
			}
			return isIn;
		}
		
		public function unitIsInCastle(unit:Unit):Boolean {
			if( pointIsInCastle(unit.x, unit.y) 
				|| pointIsInCastle(unit.x + unit.width, unit.y)
				|| pointIsInCastle(unit.x, unit.y + unit.height)
				|| pointIsInCastle(unit.x + unit.width, unit.y + unit.height)) {
				
				return true;
			}
			return false;
		}
		
		
		private function unitCostSum(unitList:FlxGroup):int {
			var cost:int = 0;
			for each (var unit:Unit in unitList.members) {
				if (unit != null) {
					cost += unit.cost; 
				}
			}
			return cost;
		}
		
		/** Returns whether a given unitID of unitType (Castle.ARMY or TOWER) is available
		 * based on current upgrades
		 * */
		public function isUnitUnlocked(unitID:int, unitType:String):Boolean {
			
			return unitsUnlocked(unitType).indexOf(unitID) >= 0;
		}
		
		public function getNamesByLevel(type:String, level:int):String {
			var result:String = "";
			var strata:String = "ground";
			if(type == "mine") {
				strata = "underground";		
			} else if(type == "aviary") {
				strata = "air";
			}
			result = unitsFromLevel(ARMY,level,strata);
			if(type == "barracks") {
				return result;
			} else if (type == "foundry") {
				return unitsFromLevel(TOWER,level,strata);
			}
			var result2:String = unitsFromLevel(TOWER,level,strata);
			if(result2.length == 0) {
				return result;
			}
			return result + ", " + result2;
		}
		
		/** Returns the unitIDs for the units unlocked by the castle's upgrade levels
		 * 
		 * @param unitType Either Castle.TOWER or Castle.ARMY to search for each type
		 * @param highest True if you want to figure out what enemies are valid to send against user
		 * @return Array of unitIDs
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
			var unitList:Array = new Array();
			unitsFromUpgradeType(unitList, typeLevel, unitType, "ground");
			unitsFromUpgradeType(unitList, _upgrades["mine"], unitType, "underground");
			unitsFromUpgradeType(unitList, _upgrades["aviary"], unitType, "air");
			
			return unitList;
		}
		
		/**
		 * Appends units unlocked of unitType by given upgrade level 
		 * @param unitList
		 * @param upgradeLevel level of mine, aviary, foundry, barracks
		 * @param unitType "air", "ground", "underground" corr. to aviary, bar/found, mine levels
		 * 
		 */		
		private function unitsFromUpgradeType(unitList:Array, upgradeLevelMax:int, unitType:String, strata:String):void {
			// Iterates over upgrade list to add all unitIDs contained
			for ( var upgradeLevel:int = 0; upgradeLevel <= upgradeLevelMax ; upgradeLevel++) {
				unitsFromLevel(unitType, upgradeLevel, strata, unitList);
			}
		}
		
		/** fills unitList with IDs unlocked at a given level*/
		private function unitsFromLevel(unitType:String,upgradeLevel:int,strata:String, unitList:Array = null):String {
			var names:String = "";
			if (UNIT_INFO[unitType].byLevel != null && UNIT_INFO[unitType].byLevel[upgradeLevel] != null) {
				for(var unitID:Object in UNIT_INFO[unitType].byLevel[upgradeLevel]) {
					if(UNIT_INFO[unitType].byLevel[upgradeLevel][unitID].clas == strata) {
						if(unitList != null) {
							unitList.push(UNIT_INFO[unitType].byLevel[upgradeLevel][unitID].uid);		
						}
						names += UNIT_INFO[unitType].byLevel[upgradeLevel][unitID].name + ", ";
					}
				}
			}
			return names.substr(0,names.length-2);
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
		
		/**
		 * 
		 * @return Array of upgrade levesl
		 * - can be accessed with requests upgrades["barracks"]
		 * - also accepts "castle, "foundry", "mine", "aviary"
		 * 
		 */		
		public function get upgrades():Array {
			return _upgrades;
		}
		
		public function get attackSeed():Number {
			return _attackSeed;
		}
		
		public function set attackSeed(newSeed:Number):void {
			_attackSeed = newSeed || .125;
		}
		
		/**
		 * Appraises the current user and returns a number.
		 *  
		 * @param person A userinfo object derived from the database or a valid castle object
		 * @return The worth of the user.
		 * 
		 */		
		public static function computeValue(person:Object):Number {
			if(person is Castle) {
				return (person as Castle).unitCapacity + (person as Castle).towerCapacity;	
			} else { // person is object
				return parseInt(person.units.toString());
			}
		}
		
		/**
		 * Returns the number of upgrades purchased. 
		 * @return the number of upgrades purchased
		 * 
		 */		
		public function get numUpgrades():Number {
			var n:Number = 0;
			for each (var value:Number in _upgrades) {
				n += value;
			}
			return n;
		}
		
		
	}
}
