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
		}
		
		override public function update():void {
			// Check if peeps are still alive
			
			// Do nothing if peeps are still alive
			if(!_activeAttack) {
				_activeAttack == true;
				// Check for incoming wave
				// if none, check for automated
				
				// else if is, lock menus and drop dudes
				var leftSide:Array;
				var rightSide:Array;
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
						leftSide.add(unitNum);
					} else {
						rightSide.add(unitNum);
					}
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
			
			placeDudes(leftSide, Util.minX);
			placeDudes(rightSide, Util.maxX);
			
		}
		
		/**
		 * Places an array of Units on the board starting at xVal x address 
		 * @param dudes Array of Units to place
		 * @param xVal X location to start placing units at
		 * 
		 */		
		private function placeDudes(dudes:Array, xVal:int):void {
			for( var i:int = 0; i < dudes.length; i++) {
				var dude:Unit;
				if (dude.type == Unit.UNDERGROUND) {
					dude = new Unit(xVal, Util.minTileY, dudes[i]);
				} else if (dude.type == Unit.AIR) {
					dude = new Unit(xVal, Util.minTileY, dudes[i]);
				} else {
					dude = new Unit(xVal, Util.minTileY, dudes[i]);
					Util.placeOnGround(dude, this.map);
				}
				units.add(dude);
			}
		}
	}
}