package
{
	import flashx.textLayout.elements.SubParagraphGroupElement;
	
	import mx.utils.StringUtil;
	
	import org.flixel.*;
	
	/**
	 * AttackState is running when the user either requested an attack wave 
	 * or there is a detected automated attack. 
	 * 
	 * It will either create a random attack or use a received set of targets
	 * 
	 * @todo : complete "endgame" scenarios
	 * 				Figure out sum of gold dropped
	 * 				Call API to update database (gold to winner)
	 * 
	 * 			Add in towers
	 * 			Complete Util integration (all units, friend waves, etc)
	 * 			
	 * 			Add user prompting ("you lost X gold", "enemy dropped Y gold");
	 *  
	 * @author Justin
	 * 
	 */	
	public class AttackState extends ActiveState
	{
		
		public static const REQUESTED:String = "request"; 
		public static const TIDAL:String = "tidal"; 
		public static const FRIEND:String = "friend"; 
		
		private static const CLICK_DAMAGE_POINTS:Number = 20;
		// The minimum time between click attacks in milliseconds
		private static const TIME_BETWEEN_CLICKS:Number = 3000;
		// Number to get to before another click attack is allowed
		private static const MIN_TICKS_BETWEEN_CLICKS:Number = TIME_BETWEEN_CLICKS / FlxG.framerate;
		private var _ticks:int;
		
		private var _activeAttack:Boolean;
		private var _droppedGold:int;
		
		private var _placeOnLeft:Array;
		private var _placeOnRight:Array;
		
		private var _unitDropCounter:int;
		private var _attackSeedValue:Number;
		
		private var _gameOver:Boolean;
		private var _waveGold:int;
		private var _pendingAttack:Object;
		
		private var _attackTypeLogging:String;
		private var _towerLogging:String;
		private var _leftArmyLogging:String;
		private var _rightArmyLogging:String;
		
		
		public function AttackState(map:FlxTilemap=null, castle:Castle = null, towers:FlxGroup = null, units:FlxGroup = null, pendingAttack:Object = null)
		{
			super(map, castle, towers, units);
			_ticks = MIN_TICKS_BETWEEN_CLICKS;
			_pendingAttack = pendingAttack;
			
			// If sent an attack wave by a friend
			if (_pendingAttack != null) {
				attackPending = true;
				_placeOnLeft = _pendingAttack.leftSide.split(",");
				_placeOnRight = _pendingAttack.rightSide.split(",");
				
				_leftArmyLogging = _placeOnLeft.join(" ");
				_rightArmyLogging = _placeOnRight.join(" ");
				_attackTypeLogging = "friend";
			}
			
			// If not a sent attack wave, generate random armies
			if (_placeOnRight == null && _placeOnLeft == null) { 
				var leftSide:Array = new Array();
				var rightSide:Array = new Array();
				generateArmy(leftSide, rightSide, 10, 10);
				
				_leftArmyLogging = leftSide.join(" ");
				_rightArmyLogging = rightSide.join(" ");
				_attackTypeLogging = "request";
				
				placeArmy(leftSide, rightSide);
				
			} 
			_activeAttack = false;
			_unitDropCounter = 10;
			
			_towerLogging = "";
			for each (var tower:Unit in towers.members) {
				if(tower != null) {
					tower.health = tower.maxHealth;
					
					// build tower info string for logging
					_towerLogging = _towerLogging + tower.ID + " " + tower.x + " " + tower.y + " ";
				}
			}
		}
		
		/**
		 * Sets up the Tilemap based on the information in FlxSave or the Database
		 * Draws tutorial UI components if tutorial is true. Draws the menu buttons on the screen.
		 * 
		 */
		override public function create():void {
			super.create();
			this.castle.resetGame();

			_gameOver = false;
			
			towers.setAll("canDrag", false);
			towers.setAll("canHighlight", false);
			
			setTutorialUI();
			
			// Generate attacking wave
			// lock menus 
			
		
		}
		
		private function setTutorialUI():void {
			toggleButtons(0);
			if (Castle.tutorialLevel == Castle.TUTORIAL_FIRST_DEFEND) {
				Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_FIRST_WAVE);
				Castle.tutorialLevel = Castle.TUTORIAL_FIRST_WAVE;
			}
		}
		
		private function waveFinished(win:Boolean):void {
			Util.log("AttackState.waveFinished: " + win, Castle.tutorialLevel);
			var winText:String = Util.assets[Assets.FIRST_WIN];
			var loseText:String = Util.assets[Assets.FIRST_LOSS];
			var prize:Number = computeStolen(units, castle.gold);

			if (_pendingAttack != null) {
				if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
					toggleButtons(4);
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
					toggleButtons(5);
				} else {
					Util.log("AttackState.waveFinished: win=" + win + ", unexpected tutorial level for pending attack");
				}
				if (win) {
					add(new MessageBox(StringUtil.substitute(Util.assets[Assets.FRIEND_WAVE_WIN], _pendingAttack.name), "Okay", null));
					Database.setWinStatusAttacks({
						uid: _pendingAttack.id,
						aid: FaceBook.uid,
						win: 0
					});
				} else {
					add(new MessageBox(StringUtil.substitute(Util.assets[Assets.FRIEND_WAVE_LOSS], _pendingAttack.name, prize), "Okay", null));
					Database.setWinStatusAttacks({
						uid: _pendingAttack.id,
						aid: FaceBook.uid,
						win: prize + 100
					});
				}
			} else if (win && Castle.tutorialLevel == Castle.TUTORIAL_FIRST_WAVE) {
				add(new MessageBox(Util.assets[Assets.FIRST_WIN], "Okay", function():void {
					toggleButtons(3);
					Database.updateUserTutorialInfo(FaceBook.uid, Castle.TUTORIAL_UPGRADE);
					Castle.tutorialLevel = Castle.TUTORIAL_UPGRADE;
				}));
			} else if (!win && Castle.tutorialLevel == Castle.TUTORIAL_FIRST_WAVE) {
					add(new MessageBox(StringUtil.substitute(Util.assets[Assets.FIRST_LOSS], castle.unitCapacity), 
							"Okay", function():void {
						toggleButtons(2);
					}));
			} else {
				if (win) {
					add(new TimedMessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_WIN], prize)));
				} else {
					prize = _droppedGold;
					add(new TimedMessageBox(StringUtil.substitute(Util.assets[Assets.ATTACK_LOSE], prize)));
				}
				if (Castle.tutorialLevel == Castle.TUTORIAL_UPGRADE){
					toggleButtons(3);
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_ATTACK_FRIENDS) {
					toggleButtons(4);
				} else if (Castle.tutorialLevel == Castle.TUTORIAL_LEASE) {
					toggleButtons(5);
				} else {
					Util.log("AttackState.waveFinished: unknown tutorial level " + Castle.tutorialLevel);
				}
			}
			remove(units);
			if (castle.leasedInUnits > 0) {
				castle.leasedInUnits = 0;
			}
			if (castle.leasedOutUnits > 0) {
				castle.leasedOutUnits = 0;
			}
		}
		
		private function checkClick():void {
			if (FlxG.mouse.justPressed() && _ticks >= AttackState.MIN_TICKS_BETWEEN_CLICKS) {
				var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
				for each (var enemy:EnemyUnit in units.members) {
					if (enemy != null && enemy.overlapsPoint(mouseCoords)) {
						var attack:OnetimeSprite = new OnetimeSprite(mouseCoords.x, mouseCoords.y, Util.assets[Assets.EXPLODE], 15, 15, [0, 1, 2, 3, 4]);
						add(attack);
						enemy.inflictDamage(CLICK_DAMAGE_POINTS * (castle.upgrades["castle"] + 1));
						_ticks = 0;
						break;
					}
				}
			} else {
				_ticks++;
			}		
		}
		
		override public function update():void {
			super.update();
			// hack for stupid null problem >_< 
			for each (var obj:FlxObject in towers.members) {
				if (obj == null) {
					towers.remove(obj);
				}
			}
			if(!_gameOver) {	
				checkClick();
				if (this.castle.isGameOver()) {		// Checks if castle has been breached
					// recover cost, units disband
					// user loses
					var armyCost:int = sumArmyCost();
					// take portion of defender's gold and give to attacker
					var cash:int = this.castle.gold;
					var cashStolen:int = computeStolen(units, cash);
					this.castle.addGold(-cashStolen);
					// Database.giveUserGold(cashStolen + armyCost);
					//GameMessages.LOSE_FIGHT("Bob Barker",6);
					_gameOver = true;
					waveFinished(false);
					
					Util.logging.userLoseAttackRound(_attackTypeLogging, 
													 _towerLogging, 
													 _leftArmyLogging,
													 _rightArmyLogging,
													 cashStolen);
					
				} else if (_placeOnLeft.length + _placeOnRight.length == 0  && units.length == 0) { // Check if peeps are still alive
					// user wins
					this.castle.addGold(this._waveGold);
					castle.attackSeed = Math.random();
					_gameOver = true;
					waveFinished(true);
					
					Util.logging.userWinAttackRound(_attackTypeLogging, 
						_towerLogging, 
						_leftArmyLogging,
						_rightArmyLogging,
						this._waveGold);
				}
				
				
				_unitDropCounter--;
				if(_unitDropCounter <= 0) {
					_unitDropCounter = 50 - Math.sqrt(units.length + _placeOnLeft.length + _placeOnRight.length);
					placeDudes(_placeOnLeft, Util.minX);
					placeDudes(_placeOnRight, Util.maxX - 20);
				}
				
			}
			super.collide();
			this.rangeCollideDetector(units,towers);
			checkCastle();
			super.update();
			
		}
		

		
		/**
		 * Check if all units are dead 
		 * @param units Group of units to check if all are dead or not
		 * @return true if all units are dead, false otherwise
		 * 
		 */		
		private function deathCheck(units:FlxGroup):Boolean {
			for each (var unit:Object in units.members) {
				unit = unit as Unit;
				if(unit == null) {
					var hi:int = 2121;
				}
				if(unit != null && unit.health > 0) {
					return false;
				}
			}
			return true;
		}
		
		private function computeStolen(units:FlxGroup, cash:int):int {
			
			var count:int = 0;
			for each(var unit:Object in units.members) {
				if(unit != null) count++;
				/*
				unit = unit as Unit;
				cap += unit.goldCapacity;
				*/
			}
			/*
			return Math.min(.7*cash, cap);
			*/
			return (.1 + Math.min(.2,(count + _placeOnLeft.length + _placeOnRight.length)/ 10))*cash;
		}
		
		
		/** Generates a random army with strength within a certain range of the user's defensive capabilities
		
		 * @param leftSide	Empty array for left side of army
		 * @param rightSide Empty array for right side of army
		 * @param lowRange	Percentage that the attacking wave's strength could be less than the user's
		 * @param highRange Percentage that the attacking wave;s strength could be higher than the user's
		 * 
		 */		
		private function generateArmy(leftSide:Array, rightSide:Array, lowRange:Number, highRange:Number):void {
			
			// gets highest upgrade level of units that army can use
			var possibleUnits:Array = this.castle.unitsUnlocked(Castle.ARMY, true); 
			
			// Creates random army size based on user's defensive capability
			var enemyCap:int = this.castle.towerCapacity;
			if ( enemyCap < 50 ) {
				enemyCap = 100;
			}
			this._attackSeedValue = FlxU.srand(castle.attackSeed);
			
			var rand:int = Math.round(FlxU.srand(_attackSeedValue)*(highRange/100*enemyCap  + lowRange/100*enemyCap)) - lowRange/100*enemyCap; // maps to -lowRange% <= rand% <= highRange%
			enemyCap += rand;
			this._attackSeedValue = FlxU.srand(_attackSeedValue);
			
			possibleUnits.sort(Unit.compareByCost);
			
			// Randomly select units from the array, reducing size each time
			// slightly emphasizes "better" units
			var remaining:int = enemyCap;
			var maxIndex:int = possibleUnits.length;
			do {
				maxIndex = highestUnit(possibleUnits, remaining, maxIndex);
				if (maxIndex >= 0 ) {
					// random index in range of array, of valid cost elements. +2 adds preference for strong units
					var randIndex:int = Math.min(maxIndex, Math.round(FlxU.srand(_attackSeedValue)*(maxIndex)));
					this._attackSeedValue = FlxU.srand(_attackSeedValue);

					var unitNum:int = possibleUnits[randIndex];
					var side:int = Math.round(FlxU.srand(_attackSeedValue));
					this._attackSeedValue = FlxU.srand(_attackSeedValue);
					if (side == 0) {
						leftSide.push(unitNum);
					} else {
						rightSide.push(unitNum);
					}
					remaining -= Castle.UNIT_INFO[Castle.ARMY][unitNum].unitCost; // cost of unit
				}
			} while (remaining > 0 && maxIndex >=0 ) ;
				
		}
		
		/**
		 * Computes highest valid unit cost remaining
		 * @param possibleUnits Sorted array of unitIDs to select from
		 * @param remaining number of remaining units to place
		 * @return total length to check
		 * 
		 */		
		private function highestUnit(possibleUnits:Array, remaining:int, prevMax:int):int {
			for(var i:int = possibleUnits.length-1; i >= 0; i--) {
				if(unitCost(possibleUnits[i]) <= remaining) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * Should be implemented in Util
		 *
 		 * @param unitId unitID to look up the cost for
		 * @return unit cost associated with given unitID
		 * 
		 */		
		private function unitCost(unitId:int):int {
			return 1;
		}
		
		/** Should be implemented in Util
		 * Fills left, right arrays with unit numbers from DB in order of
		 * which they will attack from each respective side
		 */
		private function getFriendWave(leftSide:Array, rightSide:Array):void {
			
		}
		
		/** Should be implemented in Util 
		 * @return AttackState.FRIEND if there is a friend wave in the DB
		 * AttackState.TIDAL if the tidal trigger has been sent
		 * AttackState.REQUESTED if none of these has happened (default)
		 */
		private function getAttackType():String {
			return AttackState.REQUESTED;
		}
		
		
		private function sumArmyCost():int {
			var cost:int = 0;
			for(var unit:Object in this.units) {
				unit = unit as Unit;
				cost += unit.cost;
			}
			return cost;
		}
		
		/**
		 * Places all army units for the left and right sides on the screen, 
		 * in order of their placement on the screen. 
		 * @param 
		 * @param Array
		 * @param rightSide
		 * 
		 */		
		private function placeArmy( leftSide:Array, rightSide:Array):void {
			_placeOnLeft = leftSide;
			_placeOnRight = rightSide;
		}
		
		/**
		 * Places first unit in an array of Units on the board starting at xVal x address 
		 * @param dudes Array of Units (numbers) to place
		 * @param xVal X location to start placing units at
		 * 
		 */		
		private function placeDudes(dudes:Array, xVal:int):void {
			//trace("Called PlaceUnits with size: " + dudes.length + " active attack: " + _activeAttack);
			//for( var i:int = 0; i < dudes.length; i++) {
			if (dudes == null || dudes.length <= 0 ){
				return;
			}
			var bar:HealthBar = new HealthBar();
			bar = null;
			var dude:Unit = new EnemyUnit(xVal, Util.minY, dudes[0], false, bar);
			units.add(dude);
			this.add(bar);
			this.addEnemyUnit(dude as EnemyUnit,true);
			dudes.shift();
		}
		
		public function addWaveGold(amount:int):void {
			_waveGold += amount;
		}
		
		/**
		 * Calls hitRanged on every unit in either group that comes into range of the other 
		 * Does not call on any null objects or dead units. 
		 * 
		 * @param group1 first group to rangeCollide
		 * @param grou2 second group to rangeCollide
		 * 
		 */		
		public function rangeCollideDetector(group1:FlxGroup, group2:FlxGroup):void {
			for each (var unit1:Unit in group1.members) {
				for each (var unit2:Unit in group2.members) {
					if(unit1 != null && unit2 != null && unit1.health > 0 && unit2.health > 0) {
						if(unit1.inRange(unit2) || unit1.overlaps(unit2)) {
							unit1.hitRanged(unit2);
						}
						if(unit2.inRange(unit1) || unit2.overlaps(unit1)) {
							unit2.hitRanged(unit1);
						}
					}
				} 
			} 
		}
		
		override public function drawStats():void {
			super.drawStats();
			if (!_gameOver) {
				_towerDisplay.visible = true;
			} else {
				_towerDisplay.visible = false;
			}
			_towerDisplay.value = castle.towerCapacity - castle.towerUnitsAvailable;
			_towerDisplay.max = castle.towerCapacity;
		}
		
		public function checkCastle():void {
			for each (var unit:Unit in units.members) {
				if(unit != null) {
					if( pointIsIn(unit.x, unit.y) 
						|| pointIsIn(unit.x + unit.width, unit.y)
						|| pointIsIn(unit.x, unit.y + unit.height)
						|| pointIsIn(unit.x + unit.width, unit.y + unit.height)) {
						
						castle.hitRanged(unit);
					}
				}
			}
		}
		
		/** Returns true if point is in the castle */
		private function pointIsIn(ox:int, oy:int):Boolean {
			return castle.pointIsInCastle(ox,oy);
		}
	}
}
