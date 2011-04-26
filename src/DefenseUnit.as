package
{
	import org.flixel.*;
	
	public class DefenseUnit extends Unit {
		
		private var primaryTarget:Unit = null;
		
		/**
		 * 
		 * @param x
		 * @param y
		 * @param towerID
		 * 
		 */		
		public function DefenseUnit(x:Number, y:Number, towerID:int) {
			super (x,y,towerID);
			
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * 	Sets primary target to closest Enemy unit that calls this function
		 * @param contact
		 * @param velocity
		 * 
		 */
		override public function hitRanged(contact:FlxObject, velocity:Number):void {
			super.hitRanged(contact, velocity);
			if ( contact is EnemyUnit ) {
				//primaryTarget = betterTarget(primaryTarget, contact);	
			}
		}
		/*
		/** Executes whatever attack the unit does
		 *  Returns true if the unit has used its attack, false otherwise
		 * If unit has multiple shots, it selects any 3 units in range and attacks them
		 * Defaults to false
		 *
		
		private function executeAttack():Boolean {
			if( _shots > 1) {
				var unitsInRange:Array = getUnitsInRange();
				for(var shotNum = 1; shotNum <= _shots; shotNum++) {
					unitsInRange[shotNum-1].damage(_damage);
				}
			} else if(primaryTarget != null) {
				return false;
			} else if (primaryTarget.damage(_damage)) { // deal damage
				primaryTarget = findClosestTarget();	// reset to closest target
			}
		}
		*/
		
		/** Returns better valid target:
		 * Should pass in a current target as target1 so it remains primary target 
		 * if distance is equal
		 * 
		 * Returns whichever target is not null, is still alive (health &gt; 0) and is closer
		 * Returns null if neither target is non-null and alive. (neither is valid target)
		 * */
		/*
		public function betterTarget(target1:Unit, target2:Unit):Unit {
			if (	target1 != null && target1.getHealth() > 0 
					&& distance(target1.getScreenXY(),this.getScreenXY()) <= 
					distance(target2.getScreenXY(),this.getScreenXY()) ) {
				return target1;
			} else if (target2 != null && target2.getHealth() > 0 ) {
				return target2;
			} else {
				return null;
			}
		}
		*/
	}
}