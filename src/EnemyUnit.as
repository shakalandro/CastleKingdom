/** Team AWESOME, 4/21/11
 *  EnemyUnit class
 *  Defines unit behavior specific to enemy units
 * 
 * Todo: 
 * 	Ensure ground units stay on top of land, fall/climb appropriately
 *  Ensure Air units go down to touch city *or register loss after X change)
 *  Ensure underground units follow correct pattern \__/ 
 * 	Ensure game ends when unit comes in proximity to castle
 * 
 * 
 * 
 * */

package
{
	import flash.display.BitmapData;
	
	import org.flixel.*;


	/** Unit default behavior:  
	 * 	Moves at default velocity until reaches a target, then stops. 
	 *  When stopped, attacks single target until target dies
	 * 
	 * @author Justin
	 **/
	public class EnemyUnit extends Unit implements Draggable
	{
		private var _target:Unit;
		private var _type:String; 
		private var _reward:int;
		private var _active:Boolean;
		private var _canDrag:Boolean;
		private var _invuln:int;
		private var _multiNumber:int;
		private var _multiDisplay:FlxText;

		public function EnemyUnit(x:Number, y:Number, towerID:int, canDrag:Boolean = false, bar:HealthBar = null, active:Boolean = true) {
			
			super (x,y,towerID, "barracks", bar, canDrag);
			this.speed = Castle.UNIT_INFO["barracks"][unitID].move;
			this.goldCost = Castle.UNIT_INFO["barracks"][unitID].goldCost;
			_reward = Castle.UNIT_INFO["barracks"][unitID].reward;
			this._active = active;
			_canDrag = canDrag;
			
			this.immovable = true;
			
				
			//var unitName:String = Castle.UNIT_INFO["barracks"][towerID].name;
			var imgResource:Class = Util.assets[_unitName];
			if (imgResource == null) {
				// set to default image
				imgResource = Util.assets[Assets.BLOB];
			}
			var sizer:FlxSprite = new FlxSprite(0,0,imgResource);
			this.loadGraphic(imgResource,true,true,
					sizer.width / 12,
					sizer.height,true);
			this.addAnimation("walk", [0,1,2,3],speed/2,true);
			this.addAnimation("attack",[4,5,6,7],_rate,true);
			this.addAnimation("die",[8,9,10,11],_rate, false);
			this.play("walk");
			
			if (this._active) {

				//this._type = Unit.GROUND;
				this.speed *= 2;
				this.velocity.x = speed;
				if(this.clas == "air") {
					this.velocity.y = 1;	
				}
				if(this.x > Util.maxX/2) {
					// goes left
					this.velocity.x = -speed;
					this.facing = LEFT;
				} else {
					// goes right
					this.velocity.x = speed;
					this.facing = RIGHT;
				}
			}
			
			this.canHighlight = true;
			_invuln = 20;
			
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
			
			//this.allowCollisions = FlxObject.ANY;
			//this.immovable = true;
			
		}
		
	/*	
		override public function clone():FlxBasic {
		//	var yuri:DefenseUnit = new DefenseUnit(x,y,this._unitID,true,new HealthBar());
			return yuri;

		} */
		
		/** Moves the character as needed if possible
		 * 
		 */
		override public function update():void {
			
			if (this._active) {
				_invuln--;
				if(!this.alive || this.health <= 0) {
					this.velocity.x = 0;
					this.color =  Math.random() * 0xffffffff; 
					if(this.alive) {
						this.play("die");
					}
					this.alive = false;
					if(this.finished) {
						(FlxG.state as AttackState).addWaveGold(this._reward);
						(FlxG.state as ActiveState).units.remove(this, true); 
					} else {
						//this.play("die");
					}
				} else {
					if (type == Unit.GROUND && this.y <= Util.castle.y ){
						this.velocity.y = 0 ;
					} else if (clas == Unit.AIR && this.x > (FlxG.state as ActiveState).castle.x 
								&& this.x < ((FlxG.state as ActiveState).castle.x + (FlxG.state as ActiveState).castle.width) ) {
						this.velocity.y += 1;
					} else if (clas == Unit.UNDERGROUND && this.x > (FlxG.state as ActiveState).castle.x 
						&& this.x < ((FlxG.state as ActiveState).castle.x + (FlxG.state as ActiveState).castle.width) ) {
						this.velocity.y -= 1;
					}
					if(this._target == null || _target.health <= 0) {
						this._target = null;
						if(this.x > Util.maxX/2) {
							// goes left
							this.velocity.x = -speed;
							this.facing = LEFT;
						} else {
							// goes right
							this.velocity.x = speed;
							this.facing = RIGHT;
						}
						this.play("walk");
						
						
					} else {
						
					}
				}
				super.update();
			}
		}
		
		public function setNewTarget():Boolean {
			this._target = null;
			hitRanged(this.getUnitsInRange((FlxG.state as ActiveState).towers)[0]);
			return (_target != null);
			
		}
		
		override public function preUpdate():void {
			super.preUpdate();
			if (FlxG.state is AttackFriendsState && this.checkHighlight()) {
				_infoDisplay.remove(_multiDisplay);
				if(this.name == "Dragon") {
					trace("plz break here");
				}
				//-((FlxG.state as AttackFriendsState).accumulatedUnits)
				var maxFit:int = (6/(this.width/CastleKingdom.TILE_SIZE))* (6/(this.height/CastleKingdom.TILE_SIZE));
				maxFit *= 2; // 1 for each side
				_multiNumber = ((((FlxG.state as AttackFriendsState).castle.unitCapacity)) / maxFit) / this.cost;
				_multiDisplay = new FlxText(this.x,this.y + this.height,this.width,"x" +_multiNumber);
				_multiDisplay.color = FlxG.BLACK;
				_infoDisplay.add(_multiDisplay);
				FlxG.state.add(_infoDisplay);
				var rangeSize:int = this.range*CastleKingdom.TILE_SIZE;
				_infoBox.x = this.x - rangeSize;
				_infoBox.y = this.y - rangeSize;
				if(_multiDisplay) {
					_multiDisplay.x = this.x;
					_multiDisplay.y = this.y + this.height;
				}
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
				if(this.range > 0) {
					if(this.facing == LEFT) {
						new AttackAnimation(this.x,this.y,_target,this, attackAnimationString());
					} else {
						new AttackAnimation(this.x + this.width,this.y,_target,this, attackAnimationString());
					}
				} else {
					_target.inflictDamage(this.damageDone);
				}
				return true;
			}
			return false;
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * Sets a single target, only changes it once the current target dies
		 * */
		
		override public function hitRanged(contact:FlxObject):void {
			if(contact is DefenseUnit && (this._target == null || _target.health <= 0) 
					&& (((contact as DefenseUnit).name as String).indexOf("Mine") < 0)
					&& (contact as DefenseUnit).clas == this.clas ){
				this._target = contact as Unit;
				this.velocity.y = 0;
				this.velocity.x = 0;
				this.play("attack");
			}	
		}
		
		override public function clone():Unit {
			return new EnemyUnit(x, y, unitID, canDrag, null, _active);
		}
		
		
		
		override public function kill():void {
			super.kill();
		//	this.velocity.x = 0;
		//	play("die");
			
		}
		
		private function attackAnimationString():String {
			if(checkVsArray(this.name, ["Cannon", "Iron Tower"])) {
				return "Cannonball";
			} else if(checkVsArray(this.name, ["Airplane", "Zeppelin"])) {
				return "Bullet";
			} else if(checkVsArray(this.name, ["Flame Tower", "Dragon", "Tamed Phoenix"])) {
				return "Fireball";
			} else if(checkVsArray(this.name, ["Rocket Tower"])) {
				return "Arrow";
			} else if(checkVsArray(this.name, ["Spearman"])) {
				return "Spear";
			}else {
				return "Arrow";
			}
				
			
		}
		
		private function checkVsArray(name:String, arr:Array):Boolean {
			for each (var val:String in arr) {
				if (val == name) {
					return true;
				}
			}
			return false;
		}
			
		override public function thingKilled(target:Unit):void {
			if(_target == target) {
				target = null;
			}
		}
		
		public function setMultiple(maxUnits:int):void {
			if(false) {
			// compute max number of this unit that can fit in 1 attack box
			_infoDisplay.remove(_multiDisplay);
			var maxFit:int = (6/(this.width/CastleKingdom.TILE_SIZE))* (6/(this.height/CastleKingdom.TILE_SIZE));
			maxFit *= 2; // 1 for each side
			_multiNumber = maxUnits / maxFit / 1.5;
			_multiDisplay = new FlxText(this.x,this.y + this.height,this.width,"Places\n" + _multiNumber + "\nunits");
			_multiDisplay.color = FlxG.BLACK;
			_infoDisplay.add(_multiDisplay);
			}
		}
		
		public function get multiNumber():int {
			return _multiNumber;
		}
		
	}
}
