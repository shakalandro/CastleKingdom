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
	public class DefenseUnit extends Unit implements Draggable {
		
		private var _target:FlxObject;
		
		private var _currentlyDraggable:Boolean;
		private var _dragging:Boolean;
		private var _dragCallback:Function;
		private var _preDragCoords:FlxPoint;
		private var _dragOffset:FlxPoint;
		private var _canDrag:Boolean;
		
		/**
		 * 
		 * @param x X coord to start at
		 * @param y Y coord to start at
		 * @param towerID Type of Tower to generate
		 * 
		 */		
		public function DefenseUnit(x:Number, y:Number, towerID:int, canDrag:Boolean = true, dragCallback:Function = null) {
			super (x,y,towerID);
			this.loadGraphic(Util.assets[Assets.ARROW_TOWER], true, false, CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE * 3);
			_dragging = false;
			_dragCallback = dragCallback;
			_canDrag = canDrag;
			_target = null;
		}
		
		public function get canDrag():Boolean {
			return _canDrag;
		}
		
		public function set canDrag(t:Boolean):void {
			_canDrag = t;
		}
		
		public function set dragCallback(callback:Function):void {
			_dragCallback = callback;
		}
		
		override public function preUpdate():void {
			checkDrag();
		}
		
		public function checkDrag():void {
			if (_canDrag) {
				var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
				if (FlxG.mouse.justPressed() && checkClick()) {
					_dragging = true;
					_preDragCoords = new FlxPoint(x, y);
					_dragOffset = new FlxPoint(mouseCoords.x - this.x, mouseCoords.y - this.y);
				} else if (_dragging && FlxG.mouse.justReleased()) {
					_dragging = false;
					this.x = mouseCoords.x - _dragOffset.x;
					this.y = mouseCoords.y - _dragOffset.y;
					_dragOffset = null;
					if (_dragCallback != null) _dragCallback(this, x, y, _preDragCoords.x, _preDragCoords.y);
					_preDragCoords = null;
				}
				if (_dragging) {
					this.x = mouseCoords.x - _dragOffset.x;
					this.y = mouseCoords.y - _dragOffset.y;
				}
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
			if (contact is EnemyUnit) {
				if (_target == null || _target.health <= 0) {
					_target = contact;
				}
				_target.health -= this.damageDone;
			}
		}
		
		override public function update():void {
			if (health <= 0) {
				this.kill();
			}
			this.frame = 7 - Math.floor(7 * (health / this.maxHealth));
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
			if (target1 != null && target1.health > 0 
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
