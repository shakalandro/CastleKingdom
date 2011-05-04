package 
{
	import flash.geom.*;
	
	import org.flixel.*;

	/** DefenseUnit class
	 * 
	 * Class for tower type units, controls targeting of EnemyUnits and actual execution of attack
	 * 
	 * Towers are stationary, so they never need to redraw. (in theory)
	 * 
	 * @author Justin
	 * 
	 */	
	public class DefenseUnit extends Unit {
		
		private var primaryTarget:Unit = null;
		
		private var _dragging:Boolean;
		private var _dragOffset:FlxPoint;
		
		/**
		 * 
		 * @param x X coord to start at
		 * @param y Y coord to start at
		 * @param towerID Type of Tower to generate
		 * 
		 */		
		public function DefenseUnit(x:Number, y:Number, towerID:int) {
			super (x,y,towerID);
			this.loadGraphic(Util.assets[Assets.ARROW_TOWER], true, false, CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE * 3);
			_dragging = false;
		}
		
		override public function preUpdate():void {
			var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
			if (FlxG.mouse.justPressed() && checkClick()) {
				_dragging = true;
				_dragOffset = new FlxPoint(mouseCoords.x - this.x, mouseCoords.y - this.y);
			} else if (_dragging && FlxG.mouse.justReleased()) {
				_dragging = false;
				this.x = mouseCoords.x - _dragOffset.x;
				Util.placeOnGround(this, Util.state.map, false, true);
				_dragOffset = null;
			}
			if (_dragging) {
				this.x = mouseCoords.x - _dragOffset.x;
				this.y = mouseCoords.y - _dragOffset.y;
			}
		}
		
		private function checkClick():Boolean {
			return this.overlapsPoint(FlxG.mouse.getScreenPosition(), true);
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * 	Sets primary target to closest Enemy unit that calls this function
		 * @param contact FlxObject that comes into range
		 * @param velocity Suggested velocity to change
		 * 
		 */
		override public function hitRanged(contact:FlxObject):void {
			super.hitRanged(contact);
			if ( contact is EnemyUnit ) {
				primaryTarget = betterTarget(primaryTarget, contact as Unit);	
			}
		}
		
		/** Executes whatever attack the unit does
		 *  Returns true if the unit has used its attack, false otherwise
		 * If unit has multiple shots, it selects any 3 units in range and attacks them
		 * Defaults to false
		 * 
		 * @return true if the attack is used, false if not 
		 * 
		 */
		private function executeAttack():Boolean {
			if( shots > 1) {
	/*			var unitsInRange:Array = getUnitsInRange();
				for(var shotNum = 1; shotNum <= _shots; shotNum++) {
					unitsInRange[shotNum-1].damage(_damage);
				}
				return true;  */
			} else if(primaryTarget != null) {
				return false;
			} else if (primaryTarget.inflictDamage(damageDone)) { // deal damage
	//			primaryTarget = findClosestTarget();	// reset to closest target
				return true;
			}
			return false;
		}
		
		
		/**Returns better valid target:
		 * Should pass in a current target as target1 so it remains primary target 
		 * if distance is equal
		 * 
		 * @param target1 First unit to compare
		 * @param target2 Second unit to compare
		 * @return  whichever target is not null, is still alive (health &gt; 0) and is closer or
		 * 			null if neither target is non-null and alive. (neither is valid target)
		 * 
		 */		
		public function betterTarget(target1:Unit, target2:Unit):Unit {
			if (	target1 != null && target1.health > 0 
					&& compareDistance(target1, target2) <= 0 ) {
				return target1;
			} else if (target2 != null && target2.health > 0 ) {
				return target2;
			} else {
				return null;
			}
		}
	
	}
}
