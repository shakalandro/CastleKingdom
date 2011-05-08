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
	public class DefenseUnit extends Unit implements Draggable, Highlightable {
		
		private var _target:Unit;
		
		private var _dragging:Boolean;
		private var _dragCallback:Function;
		private var _preDragCoords:FlxPoint;
		private var _dragOffset:FlxPoint;
		private var _canDrag:Boolean;
		
		private var _canHighlight:Boolean;
		private var _highlightCallback:Function;
		private var _highlighted:Boolean;
		
		/**
		 * 
		 * @param x X coord to start at
		 * @param y Y coord to start at
		 * @param towerID Type of Tower to generate
		 * 
		 */		
		public function DefenseUnit(x:Number, y:Number, towerID:int, canDrag:Boolean = true, dragCallback:Function = null, 
					canHighlight:Boolean = true, highlightCallback:Function = null) {
			super (x,y,towerID, "foundry");
			var unitName:String = Castle.UNIT_INFO["foundry"][towerID].name;
			var imgResource:Class = Util.assets[unitName];
			//imgResource.bitMapData.height; 
			if (imgResource == null) {
				// set to default image
				imgResource = Util.assets[Assets.ARROW_TOWER];
			}
			var sizer:FlxSprite = new FlxSprite(0,0,imgResource);
			
			trace("img dimensions = " + (imgResource).width +" by " + (imgResource).height);
			this.loadGraphic(imgResource,true,true,	sizer.width / 8,	sizer.height, true);
			
			//loadGraphic(Util.assets[Assets.ARROW_TOWER], true, false, CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE * 3);
			addAnimation("normal", [1,2,3,4],1,false);
			addAnimation("die", [5, 6, 7], 1, false);
			addAnimation("highlight", [0], 1, true); 
			_dragging = false;
			_dragCallback = dragCallback;
			_canDrag = canDrag;
			_canHighlight = canHighlight;
			_highlightCallback = highlightCallback;
			_highlighted = false;
			_target = null;
			this.range = 6;
		}
		
		public function get canHighlight():Boolean {
			return _canHighlight;
		}
		
		public function set canHighlight(t:Boolean):void {
			_canHighlight = t;
		}
		
		public function set highlightCallback(callback:Function):void {
			_highlightCallback = callback;
		}
		
		public function get highlighted():Boolean {
			return _highlighted;
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
			_highlighted = checkHighlight();
		}
		
		public function checkDrag():Boolean {
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
					return true;
				}
			}
			return false;
		}
		
		public function checkHighlight():Boolean {
			if (_canHighlight) {
				var mouseCoords:FlxPoint = FlxG.mouse.getScreenPosition();
				if (checkClick()) {
					return true;
				}
			}
			return false;
		}
		
		override public function executeAttack():Boolean {
			if(_target != null) {
				if(_target.inflictDamage(this.damageDone)){
					_target = null;
				}
				return true;
			}
			return false;
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
		//	super.hitRanged(contact);
			if (contact is EnemyUnit) {
				if (_target == null || _target.health <= 0) {
					_target = contact as Unit;
				}
			}
		}
		
		override public function update():void {
			if (health <= 0) {
			}
			if(this._target == null) {
				this.color =  0xcccccccc; 
				//this.checkRangedCollision();
				_target = this.getUnitsInRange()[0];
				//trace(""+_target);
			} else {
				this.color = 0xffffffff; 
			}
			
			if (_highlighted) {
				frame = 0;
			} else {
				this.frame = 6 - Math.floor(6 * Math.sqrt((health / this.maxHealth)));
			}
			super.update();
		}
		
		override public function kill():void {
			play("die");
			super.kill();
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
		
		override public function clone():FlxBasic {
			return new DefenseUnit(x, y, unitID, _canDrag, _dragCallback, _canHighlight, _highlightCallback);
		}
	}
}
