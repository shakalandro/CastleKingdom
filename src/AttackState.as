package
{
	import org.flixel.*;
	
	/**
	 * AttackState is running when the user either requested an attack wave 
	 * or there is a detected automated attack. 
	 * 
	 * It will either create a random attack or use a received set of targets
	 *  
	 * @author Justin
	 * 
	 */	
	public class AttackState extends ActiveState
	{
		
		public static const REQUESTED:String = "request"; 
		public static const TIDAL:String = "tidal"; 
		public static const FRIEND:String = "friend"; 
		
		private var _activeAttack:Boolean;
		private var _droppedGold:int;
		
		
		
		public function AttackState(tutorial:Boolean=false, menusActive:Boolean=false, map:FlxTilemap=null)
		{
			super(tutorial, menusActive, map);
			_activeAttack = false;
		}
		
		override public function update():void {
			// chekc if castle has been hit
			if(this.castle.isGameOver()) {
				// take portion of gold and give to attacker
				for(var unit:Object in this.units) {
					(unit as Unit).destroy();
				}
			} else if ( deathCheck(this.units)) {
				
			}
			// Check if peeps are still alive
			
			// Do nothing if peeps are still alive
			if(!_activeAttack) {
				_activeAttack = true;
				// Check for incoming wave
				// if none, check for automated
				
				// else if is, lock menus and drop dudes
				var leftSide:Array = new Array();
				var rightSide:Array = new Array();
				var type:String = getAttackType();
				if (type == AttackState.REQUESTED){
					generateArmy(leftSide, rightSide, 10, 10);
				} else if ( type == AttackState.TIDAL ) {
					generateArmy(leftSide, rightSide, 0, 10);
				} else {  //== AttackState.REQUESTED
					getFriendWave(leftSide, rightSide);
				}
				placeArmy(leftSide, rightSide);
			}
			super.collide();
			super.update();
			
		}
		
		/**
		 * Check if all units are dead 
		 * @param units Group of units to check if all are dead or not
		 * @return true if all units are dead, false otherwise
		 * 
		 */		
		private function deathCheck(units:FlxGroup):Boolean {
			for(var unit:Object in units) {
				unit = unit as Unit;
				if(unit.health > 0) {
					return false;
				}
			}
			return true;
		}
		
		/** Generates a random army with strength within a certain range of the user's defensive capabilities
		
		 * @param leftSide	Empty array for left side of army
		 * @param rightSide Empty array for right side of army
		 * @param lowRange	Percentage that the attacking wave's strength could be less than the user's
		 * @param highRange Percentage that the attacking wave;s strength could be higher than the user's
		 * 
		 */		
		private function generateArmy(leftSide:Array, rightSide:Array, lowRange:Number, highRange:Number):void {
			var possibleUnits:Array = this.castle.unitsUnlocked(Castle.ARMY, true); // gets highest upgrade level of units
			var enemyCap:int = this.castle.towerCapacity;
			var rand:int = Math.round(Math.random()*(highRange/100*enemyCap  + lowRange/100*enemyCap)) - lowRange/100*enemyCap; // maps to -lowRange% <= rand% <= highRange%
			enemyCap += rand;
			possibleUnits.sort(Unit.compare);
			
			// Randomly select units from the array, reducing size each time
			// slightly emphasizes "better" units
			var remaining:int = enemyCap;
			var maxIndex:int = possibleUnits.length;
			do {
				maxIndex = highestUnit(possibleUnits, remaining, maxIndex);
				if (maxIndex >= 0 ) {
					// random index in range of array, of valid cost elements. +2 adds preference for strong units
					var randIndex:int = Math.min(maxIndex, Math.round(Math.random()*(maxIndex + 2))); 
					var unitNum:int = possibleUnits[rand];
					var side:int = Math.round(Math.random()*2);
					if (side == 0) {
						leftSide.push(unitNum);
					} else {
						rightSide.push(unitNum);
					}
					remaining -= 2; // cost of unit
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
		
		/**
		 * Places all army units for the left and right sides on the screen, 
		 * in order of their placement on the screen. 
		 * @param 
		 * @param Array
		 * @param rightSide
		 * 
		 */		
		private function placeArmy( leftSide:Array, rightSide:Array):void {
			placeDudes(leftSide, Util.minX+ 100);
			placeDudes(rightSide, Util.maxX- 100);
			
		}
		
		/**
		 * Places an array of Units on the board starting at xVal x address 
		 * @param dudes Array of Units to place
		 * @param xVal X location to start placing units at
		 * 
		 */		
		private function placeDudes(dudes:Array, xVal:int):void {
			trace("Called PlaceUnits with size: " + dudes.length + " active attack: " + _activeAttack);
			for( var i:int = 0; i < dudes.length; i++) {
				var dude:Unit = new EnemyUnit(xVal-10*i, Util.minTileY, dudes[i]);;
				if (dude.type == Unit.UNDERGROUND) {
					// set dude on ground dude 
				} else if (dude.type == Unit.AIR) {
					// set dude on air dude = new Unit(xVal, Util.minTileY, dudes[i]);
				} else {
					//dude = new Unit(xVal, Util.minTileY, dudes[i]);
					Util.placeOnGround(dude, this.map);
				}
				units.add(dude);
				//trace("adding dude: " + dude.x + " " + dude.y);
				this.add(dude);
			}
		}
	}
}