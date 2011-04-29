/** Team AWESOME, 4/20/2011
 * 
 * SuperType for a generic Unit type
 * Stores Unit information, getters/setters to access it
 * 
 **/

package 
{	
	import flash.geom.*;
	
	import org.flixel.*;
	

	
	public class Unit extends FlxSprite
	{
		
		public static const AIR:String = "fly"; 
		public static const GROUND:String = "land"; 
		public static const UNDERGROUND:String = "mole"; 
		public static const WALL:String = "wall";
		public static const TOWER:String = "tower";
		
		
		
		// Whatever fields exist for all units
		// Associated getters/setters should also be in place
		
		//Basic info
		protected var _unitID:int;
		private var _cost:int;
		private var _goldCost:int;
		private var _units:int;  // ?? idk what this is
		private var _img:Class;
		
		private var _speed:int;
		
		// HP
		private var _maxHealth:Number;
		private var _health:Number;
		
		// Attack
		private var _range:int;
		private var _damageDone:int;
		protected var _rate:Number;
		private var _shots:int;
		
		private var _validTargets:Array;  // stores all enemies that come into range
		
		//private var _unitTimer:Timer;
		private var _attackCounter:Number;
		private var _type:String;
		
		// Constructs a DefenseUnit at (x, y) with the given towerID, looking
		// up what its stats are based on its tower ID
		public function Unit(x:Number, y:Number, unitID:int) {
			super (x,y,null);
			if (this.x < Util.castle.x) {
				velocity.x = FlxG.timeScale * _speed;
			} else {
				velocity.x = FlxG.timeScale * - _speed;
			}
			// look up unit info, set fields
			// {cost, goldCost, maxHealth,speed,range,damage,rate)
			
			var unitStats:Array = [1,10,50,1,1,10,1] ;//unitStatLookup(unitID);
				
			_cost = unitStats[0];
			_goldCost = unitStats[1];
			_maxHealth = unitStats[2];
			_speed = unitStats[3];
			_range = unitStats[4];
			_damageDone = unitStats[5];
			_rate = unitStats[6];
			
			// Set default fields
			health = _maxHealth;
			//_img = GLOBALLOOKUP[SKIN][unitID];
			_attackCounter = 100/_rate;
			
		}
		
		
		/** Initiates check for all units in range
		 * If attack timer allows (based on rate), calls executeAttack function 
		 * If the attack returns true (did do an attack), restarts timer for next attack time
		 * Moves the character as needed if possible
		 * */
		override public function update():void {
			_attackCounter--;
			if(_attackCounter <= 0) {				//first check if this unit's timer has expired
				if(executeAttack()) {		// Tries to attack if possible, fails if no units in range
					_attackCounter = 100/_rate;
				}
			}
			super.update();
		}
		
		/*
		/** Calls hitRanged(contact, velocity) for any units in range of the current item
		 **
		private function checkRangedCollision():void {
			for (var otherUnit:Unit in getUnitsInRange()) {
				if(otherUnit == null) {
					break;
				}
				this.hitRanged(otherUnit);
			}
		}
		*/
		
		/*
		/** Returns a null terminated array of all units within the range of this, sorted by proximity.
		 * What do arrays store by default? Out of bounds?
		 * 
		
		private function getUnitsInRange():Array {
			var unitsInRange:Array = new Array();
			var foundTarget:Boolean = false;
			for ( ALL_UNITS_ON_BOARD) {
				if( this.unitDistance(otherUnit) < this._range ) {
					unitsInRange.push(otherUnit);
					foundTarget = true;
				}
			}
			unitsInRange.push(null);
			if(!foundTarget) {
				unitsInRange[0] = null;
				return unitsInRange;
			}
			return unitsInRange.sort(compareDistance);
		}
		*/
		
		/** Executes whatever attack the unit does
		 *  Returns true if the unit has used its attack, false otherwise
		 * Defaults to false
		 * */
		private function executeAttack():Boolean {
			return false;
		}
		
		/** Returns the lowest cost from any corner of this unit to any corner of the other unit
		 * Feature or bug? Checking vertices only means edge-edge min distances will be ignored
		 * this will only happen if the units are semi-overlapping and offset from each other (share no vertexes at same level)
		 * */	
		private function unitDistance(otherUnit:Unit):Number {
			var thisPoints:Array = new Array();
			thisPoints[0] = new Point(this.x,this.y);
			thisPoints[1] = new Point(this.x + this.width, this.y);
			thisPoints[2] = new Point(this.x, this.y + this.height);
			thisPoints[3] = new Point(this.x + this.width, this.y + this.height);
	
			var othPoints:Array = new Array();
			othPoints[0] = new Point(this.x,this.y);
			othPoints[1] = new Point(this.x + this.width, this.y);
			othPoints[2] = new Point(this.x, this.y + this.height);
			othPoints[3] = new Point(this.x + this.width, this.y + this.height);
			var lowCost:Number = Point.distance(thisPoints[0], othPoints[0]);
			for (var i:int = 0; i < 4; i++) {
				for(var j:int = 0; j< 4; i++) {
					lowCost = Math.min(lowCost, Point.distance(thisPoints[i],othPoints[j]));
				}
			}
	
			return lowCost;
		}
		
		/** Getters and setters
		 * There should be getters and setters for each of the above fields except _img
		 * */
		
		public function get maxHealth():int {
			return _maxHealth;
		}
		
		public function get cost():int {
			return _cost;
		}
	
		public function get goldCost():int {
			return _goldCost;
		}
		public function get speed():int {
			return _speed;
		}
		public function get range():int {
			return _range;
		}
		public function get damageDone():int {
			return _damageDone;
		}
		public function get rate():int {
			return _rate;
		}
		public function get shots():int {
			return _shots;
		}
		
		public function set maxHealth(value:int):void {
			_maxHealth = value;
		}
		
		public function set cost(value:int):void {
			_cost = value;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function set goldCost(value:int):void {
			_goldCost = value;
		}
		public function set speed(value:int):void {
			_speed = value;
		}
		public function set range(value:int):void {
			_range = value;
		}
		public function set damageDone(value:int):void {
			_damageDone = value;
		}
		public function set rate(value:int):void {
			_rate = value;
		}
		
		
		/** Lowers unit's health by damageDealth
		 * Returns true and calls killUnit() if this reduces unit health to &lt;= 0
		 * else returns false
		 * */
		public function inflictDamage(damageDealt:int):Boolean {
			this._health -= damageDealt;
			if (this._health <= 0) {
				this.kill();
				return true;
			} else {
				return false;
			}
			
		}
		
		/** Called when this unit's health is reduced to &lt;= 0
		 * */
		override public function destroy():void {
			
		}
		
		protected function rescale(scalar:Number):void {
			//this.scale.x = scalar;
			//this.scale.y = scalar;
			this.color = 0xffffff;
			//this.offset.x = -20;
			//this.offset.y = -20;
			this.width = this.width * scalar;
			this.height = this.height * scalar;
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * */
		public function hitRanged(contact:FlxObject, velocity:Number):void {
			if ( contact is Unit ) {
				
			}
		}
		
		/** Responds appropriately to any collisions that may have taken place
		 * Relies on hitRanged to set target to closest.
		 * */
		override public function hitLeft(contact:FlxObject, velocity:Number):void {
			hitRanged(contact,velocity);
		}
		override public function hitRight(contact:FlxObject, velocity:Number):void {
			hitRanged(contact,velocity);
		}
		override public function hitTop(contact:FlxObject, velocity:Number):void {
			hitRanged(contact,velocity);
		}
		override public function hitBottom(contact:FlxObject, velocity:Number):void {
			hitRanged(contact,velocity);
		}
		
		
		
		/** Returns a typical compareTo int for unit1 and unit2
		 *  DefenseUnits are sorted first by unit cost, then by health, attack power, range, 
		 *  further ties are arbitrarily broken (returns 0)
		 * 
		 * @param unit1 	First unit to compare
		 * @param unit2		Second unit to compare
		 * @return 			1 if First unit costs more, has more health, attack or range. 
		 * 					0 if all stats are equal
		 * 					-1 otherwise
		 * 
		 */
		public static function compare(unit1:Unit, unit2:Unit):int {
			if( unit1.cost != unit2.cost ) {
				return unit1.cost - unit2.cost;
			} else if (unit1.maxHealth != unit2.maxHealth) {
				return unit1.maxHealth - unit2.maxHealth;
			} else {
				return unit1.damageDone - unit2.damageDone;
			}
		}
		
		/** Compares the distance from two other units to the current Unit
		 *
		 * @param unit1 1st unit to compare
		 * @param unit2 2nd unit to compare
		 * @return 1 if unit1 is closer, 0 if they are equally distance, 
		 * -1 if unit2 is closer
		 * 
		 */		
		public function compareDistance(unit1:Unit, unit2:Unit):int {
			var dThis:Number = this.unitDistance(unit1);
			var dOth:Number = this.unitDistance(unit2);
			if ( dThis > dOth ) {
				return 1;
			} else if ( dThis == dOth ) {
				return 0;
			} else {
				return -1;
			}
		}
		
		private function hi():void {
			
		}
	}
}
