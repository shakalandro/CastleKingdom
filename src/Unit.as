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
		
		// Attack
		private var _range:int;
		private var _damageDone:int;
		protected var _rate:Number;
		private var _shots:int;
		
		private var _validTargets:Array;  // stores all enemies that come into range
		
		//private var _unitTimer:Timer;
		private var _attackCounter:Number;
		private var _type:String;
		private var _goldCapacity:int;
		
		private var _healthyBar:HealthBar;
		private var _currentlyDraggable:Boolean;

		private var _creator:String;
		protected var _unitName:String;
		
		/** Constructs a DefenseUnit at (x, y) with the given towerID, looking
		// up what its stats are based on its tower ID
		 * 
		 * @param x
		 * @param y
		 * @param unitID - this unit's id number
		 * @param unitType "barracks" or "foundry" 
		 * @param canDrag - boolean to see if this unit is draggable or not
		 * @param hpBar - optional HealthBar to keep track of unit's health
		 * 
		 */		
		public function Unit(x:Number, y:Number, unitID:int, unitType:String, canDrag:Boolean = false, hpBar:HealthBar = null) {
			super (x,y,null);
			if (this.x < Util.castle.x) {
				velocity.x = FlxG.timeScale * _speed;
			} else {
				velocity.x = FlxG.timeScale * - _speed;
			}
			//this.immovable = true;
			
			// look up unit info, set fields
			// {cost, goldCost, maxHealth,speed,range,damage,rate)
			_creator = unitType
			_unitID = unitID;
			_unitName = Castle.UNIT_INFO[unitType][unitID].name;
			_cost = Castle.UNIT_INFO[unitType][unitID].unitCost;
			_goldCost = Castle.UNIT_INFO[unitType][unitID].goldCost;
			_maxHealth = Castle.UNIT_INFO[unitType][unitID].maxHealth;
			_range = Castle.UNIT_INFO[unitType][unitID].range;
			_damageDone = Castle.UNIT_INFO[unitType][unitID].damage;
			_rate = Castle.UNIT_INFO[unitType][unitID].rate;
			this.speed = 0;
			
			// Set default fields
			health = _maxHealth;
			resetAttackCounter();			
			_healthyBar = hpBar;
			if (_healthyBar != null) {
				trace("Starting health bar");
				_healthyBar.start(x,y,this._maxHealth,this.width);
			}
			
			
		}
		
		/** Initiates check for all units in range
		 * If attack timer allows (based on rate), calls executeAttack function 
		 * If the attack returns true (did do an attack), restarts timer for next attack time
		 * Moves the character as needed if possible
		 * */
		override public function update():void {
			if(Castle.ACID_TRIP_MODE) {
				this.color =  Math.random() * 0xffffffff;
				
			}
			if(this.health <= 0) {
				super.update();
				return;
			}
			//this.draw(_healthyBar);
			if (_healthyBar != null) {
				_healthyBar.updateLoc(x,y,this.health, this.width);
			} 
			_attackCounter--;
			if(_attackCounter <= 0) {				//first check if this unit's timer has expired
				if(executeAttack()) {		// Tries to attack if possible, fails if no units in range
					resetAttackCounter();
				}
			}
			super.update();
		}
		
		private function resetAttackCounter():void {
			_attackCounter = 250/rate;
		}
		
		/** Calls hitRanged(contact, velocity) for any units in range of the current item
		**/
		protected function checkRangedCollision(units:FlxGroup):void {
			for each (var otherUnit:String in getUnitsInRange(units)) {
				if(otherUnit == null) {
					//break;
				}
				this.hitRanged(otherUnit as EnemyUnit);
			}
		}
		
		
		
		/** Returns a null terminated array of all units within the range of this, sorted by proximity.
		* What do arrays store by default? Out of bounds?
		*/
		
		protected function getUnitsInRange(units:FlxGroup):Array {
			var unitsInRange:Array = new Array();
			var foundTarget:Boolean = false;
			//trace("Units: " + (FlxG.state as ActiveState).units.length + " range: " + this.range);
			for each ( var unit:Unit in units.members ) {
				trace("dist: " + this.unitDistance(unit as Unit) + " range: " + this._range*CastleKingdom.TILE_SIZE);
				if( (unit != null) && (unit as Unit).health >= 0 && this.unitDistance(unit as Unit) <= this._range*CastleKingdom.TILE_SIZE ) {
					unitsInRange.push(unit as Unit);
					foundTarget = true;
				}
			}
		//	trace(unitsInRange.length);

			//unitsInRange.push(null);
			if(!foundTarget) {
				unitsInRange[0] = null;
				return unitsInRange;
			}
			return unitsInRange.sort(compareDistance);
		}
		
		
		/** Executes whatever attack the unit does
		 *  Returns true if the unit has used its attack, false otherwise
		 * Defaults to false
		 * */
		public function executeAttack():Boolean {
			return false;
		}
		
		/** Returns the lowest cost from any corner of this unit to any corner of the other unit
		 * Feature or bug? Checking vertices only means edge-edge min distances will be ignored
		 * this will only happen if the units are semi-overlapping and offset from each other (share no vertexes at same level)
		 * */	
		private function unitDistance(otherUnit:Unit):Number {
			if(otherUnit == null) {
				return int.MAX_VALUE;
			}
			var thisPoints:Array = new Array();
			thisPoints[0] = new Point(this.x,this.y);
			thisPoints[1] = new Point(this.x + this.width, this.y);
			thisPoints[2] = new Point(this.x, this.y + this.height);
			thisPoints[3] = new Point(this.x + this.width, this.y + this.height);
			
			var othPoints:Array = new Array();
			othPoints[0] = new Point(otherUnit.x,otherUnit.y);
			othPoints[1] = new Point(otherUnit.x + otherUnit.width, otherUnit.y);
			othPoints[2] = new Point(otherUnit.x, otherUnit.y + otherUnit.height);
			othPoints[3] = new Point(otherUnit.x + otherUnit.width, otherUnit.y + otherUnit.height);
			var lowCost:Number = Point.distance(thisPoints[0], othPoints[0]);
			for (var i:int = 0; i < 4; i++) {
				for(var j:int = 0; j< 4; j++) {
					lowCost = Math.min(lowCost, Point.distance(thisPoints[i],othPoints[j]));
				}
			}
			
			return lowCost;
		}
		
		/** Getters and setters
		 * There should be getters and setters for each of the above fields except _img
		 * */
		
		public function get name():String {
			return _unitName;
		}
		
		public function get objx():Number {
			return x;
		}
		
		public function set objx(newX:Number):void {
			x = newX;
		}
		
		public function get objy():Number {
			return y;
		}
		
		public function set objy(newY:Number):void {
			y = newY;
		}
		
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
		
		public function get unitID():int {
			return _unitID;
		}
		
		public function get type():String {
			return _type;
		}
		
		public function get goldCapacity():int {
			return _goldCapacity;
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
			if(this.health <= 0) return true;
			
			this.health -= damageDealt;
			if (this.health <= 0) {
				//this.kill();
				return true;
			} else {
				return false;
			}
			
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
		public function hitRanged(contact:FlxObject):void {
			Util.log("Unit hitranged called");
			if ( contact is Unit ) {
				
			}
		}
		
		/** Responds appropriately to any collisions that may have taken place
		 * Relies on hitRanged to set target to closest.
		 * */
		public function hitLeft(contact:FlxObject, velocity:Number):void {
			hitRanged(contact);
		}
		public function hitRight(contact:FlxObject, velocity:Number):void {
			hitRanged(contact);
		}
		public function hitTop(contact:FlxObject, velocity:Number):void {
			hitRanged(contact);
		}
		public function hitBottom(contact:FlxObject, velocity:Number):void {
			hitRanged(contact);
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
		
		/** compares by unit cost */
		public static function compareByCost(unit1:int, unit2:int):int {
			
			return Castle.UNIT_INFO["barracks"][unit1].cost -  Castle.UNIT_INFO["barracks"][unit2].cost;
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
			if (dThis > dOth) {
				return 1;
			} else if ( dThis == dOth ) {
				return 0;
			} else {
				return -1;
			}
		}
		
		public function clone():FlxBasic {
			var yuri:Unit = new Unit(x,y,this._unitID, _creator, true, new HealthBar());
			return yuri;
		}
		
		override public function kill():void{
			this.alive = false;
			super.kill();
			
		}
	}
}
