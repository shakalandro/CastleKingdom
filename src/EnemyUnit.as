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
 * */

package
{
	import org.flixel.*;

	/** Unit default behavior:  
	 * 	Moves at default velocity until reaches a target, then stops. 
	 *  When stopped, attacks single target until it dies
	 **/
	public class EnemyUnit extends Unit
	{
		private var _target:Unit;
		private var _type:String; 
		private var _reward:int;

		public function EnemyUnit(x:Number, y:Number, towerID:int, canDrag:Boolean = false, bar:HealthBar = null) {
			
			super (x,y,towerID, "barracks", canDrag, bar);
			this.speed = Castle.UNIT_INFO["barracks"][unitID].move;
			this.goldCost = Castle.UNIT_INFO["barracks"][unitID].goldCost;
			_reward = Castle.UNIT_INFO["barracks"][unitID].reward;
			
			this._type = Unit.GROUND;
			this.speed *= 2;
			this.velocity.x = speed;
			this.velocity.y = 1;
			//var unitName:String = Castle.UNIT_INFO["barracks"][towerID].name;
			var imgResource:Class = Util.assets[_unitName];
			if (imgResource == null) {
				// set to default image
				imgResource = Util.assets[Assets.WALL];
			}
			var sizer:FlxSprite = new FlxSprite(0,0,imgResource);
			this.loadGraphic(imgResource,true,true,
					sizer.width / 12,
					sizer.height,true);
			this.addAnimation("walk", [0,1,2,3],speed/2,true);
			this.addAnimation("attack",[4,5,6,7],_rate,true);
			this.addAnimation("die",[8,9,10,11],_rate, false);
			this.play("walk");
			if(this.x > Util.maxX/2) {
				// goes left
				this.velocity.x = -speed;
				this.facing = LEFT;
			} else {
				// goes right
				this.velocity.x = speed;
				this.facing = RIGHT;
			}

			
			
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
			if(!this.alive || this.health <= 0) {
				this.velocity.y = 2; //-this.speed;
				this.velocity.x = 0;
				this.color =  Math.random() * 0xffffffff; 
				
				this.alive = false;
				if(this.finished) {
					(FlxG.state as AttackState).addWaveGold(this._reward);
					(FlxG.state as ActiveState).units.remove(this); 
				} else {
					this.play("die");
				}
			} else {
				if (type == Unit.GROUND && this.y <= Util.castle.y ){
					this.velocity.y = 0 ;
				}
				if(this._target == null || _target.health <= 0) {
					_target = null;
					var newTarget:Boolean = false;
					if (range > 1) {
						newTarget = setNewTarget() ;	
					} 
					if(!newTarget) {
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
						
					}
				} else {
					
				}
			}
			super.update();
		}
		
		public function setNewTarget():Boolean {
			this._target = null;
			hitRanged(this.getUnitsInRange((FlxG.state as ActiveState).towers)[0]);
			if(this._unitName == "Archer") {
				var _bobbo:int = 1;
			}
			return (_target != null);
			
		}
		
		
		override public function executeAttack():Boolean {
			if(_target != null) {
				_target.inflictDamage(this.damageDone);
				return true;
			}
			return false;
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * Sets a single target, only changes it once the current target dies
		 * */
		
		override public function hitRanged(contact:FlxObject):void {
			if(contact is DefenseUnit && (this._target == null || _target.health <= 0)) {
				this._target = contact as Unit;
				this.velocity.y = 0;
				this.velocity.x = 0;
				this.play("attack");
			}	
		}
		
		
		
		override public function kill():void {
			super.kill();
		//	this.velocity.x = 0;
		//	play("die");
			
		}
	}
}
