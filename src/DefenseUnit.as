package 
{
	import flash.display.BitmapData;
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
		
		private var _target:Unit;
		
		
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
				imgResource = Util.assets[Assets.SPACENEEDLE];
			}
			var sizer:FlxSprite = new FlxSprite(0,0,imgResource);
			
			this.loadGraphic(imgResource,true,true,	sizer.width / 8,	sizer.height, true);
			
			//loadGraphic(Util.assets[Assets.ARROW_TOWER], true, false, CastleKingdom.TILE_SIZE, CastleKingdom.TILE_SIZE * 3);
			addAnimation("normal", [1,2,3,4],1,false);
			addAnimation("die", [5, 6, 7], 10, false);
			addAnimation("highlight", [0], 1, true); 
			_target = null;
			
			
			
			_infoDisplay = new FlxGroup();
			var rangeSize:int = this.range*CastleKingdom.TILE_SIZE;
			var rangeCircle:BitmapData = new BitmapData(rangeSize*2 + width, rangeSize*2 + height, true, FlxG.GREEN);
			_infoBox = new FlxSprite(this.x - rangeSize, this.y - rangeSize);
			_infoBox.makeGraphic(rangeSize*2 + width, rangeSize*2 + height, FlxG.GREEN);
			_infoBox.alpha = .25;
			_description = new FlxText(this.x - rangeSize, this.y - rangeSize, 75, 
				this.clas.toUpperCase() +
				"\n\nCost: " + this.cost + 
				"\nHP: " + this.health +
				"\nDmg: " + this.damageDone +
				"\nRange: " + this.range +
				"\nROF: " + this.rate +
				"\n");
			_description.color = FlxG.BLACK;
			_infoDisplay.add(_infoBox);
			_infoDisplay.add(_description);
			_infoBox.visible = false;
			_description.visible = false;
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			if (checkHighlight()) {
				FlxG.state.add(_infoDisplay);
				var rangeSize:int = this.range*CastleKingdom.TILE_SIZE;
				_infoBox.x = this.x - rangeSize;
				_infoBox.y = this.y - rangeSize;
				_description.x = this.x + width + 3, 
					_description.y = this.y;
				_infoBox.visible = true;
				_description.visible = true;
			} else {
				FlxG.state.remove(_infoDisplay);
				
				//_infoBox.visible = false;
				//_description.visible = false;
			}
			
		}
		
		
		override public function executeAttack():Boolean {
			if(_target != null) {
				if(type == "Mine") {
					this.health = 0;
				} else if (this.range > 0) {
					new AttackAnimation(this.x,this.y,_target);
				}
				if(_target.inflictDamage(this.damageDone)){
					_target = null;
				}
				
				return true;
			}
			return false;
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
				
				if(this.finished) {
					(FlxG.state as ActiveState).remove(this._infoBox); 
					(FlxG.state as ActiveState).towers.remove(this, true); 
				//	this.kill();
					//	this.kill();
				} else {
					this.play("die");
					
				}
				
			} else {
				
				
				if(this.x > Util.maxX/2) {
					// goes left
					this.facing = LEFT;
				} else {
					// goes right
					this.facing = RIGHT;
				}
				if(this._target == null) {
					this.color =  0xcccccccc;  // Idle indicator
				} else {
					this.color = 0xffffffff;  // Attacking indicator
				}
				
				if (highlighted) {
					frame = 0;
				} else {
					this.frame = 4 - Math.floor(3 * Math.sqrt((health / this.maxHealth)));
				}
			}
			super.update();
		}
		
		override public function kill():void {
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
		
		override public function clone():Unit {
			return new DefenseUnit(x, y, unitID, canDrag, dragCallback, canHighlight, highlightCallback);
		}
	}
}
