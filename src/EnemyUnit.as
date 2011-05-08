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

		public function EnemyUnit(x:Number, y:Number, towerID:int, canDrag:Boolean = false, bar:HealthBar = null) {
			
			super (x,y,towerID, "barracks", canDrag, bar);
			this._type = Unit.GROUND;
			
			this.speed = 20;
			this.velocity.x = speed;
			var unitName:String = Castle.UNIT_INFO["barracks"][towerID].name;
			var imgResource:Class = Util.assets[unitName];
			if (imgResource == null) {
				// set to default image
				imgResource = Util.assets[Assets.WALL];
			}
			var sizer:FlxSprite = new FlxSprite(0,0,imgResource);
			this.loadGraphic(imgResource,true,true,
					sizer.width / 12,
					sizer.height,true);
			this.addAnimation("walk", [0,1,2,3],speed/2,true);
			this.addAnimation("attack",[4,5,6,7],_rate*2,true);
			this.addAnimation("die",[8,9,10,11],_rate*2, false);
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
			this.health = 100;
			
			
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
			if(!this.alive) {
				if(this.finished) {
					(FlxG.state as ActiveState).units.remove(this); 
				}
			} else {
				if (type == Unit.GROUND && this.y <= Util.castle.y ){
					this.velocity.y = 0 ;
				}
				if(this._target == null || _target.health <= 0) {
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
					_target = null;
				} else {
					
				}
			}
			super.update();
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
			this.color =  Math.random() * 0xffffffff; 
			this.velocity.y = 2; //-this.speed;
			this.velocity.x = 0;
			this.play("die");
			this.alive = false;
			
		//	this.velocity.x = 0;
		//	play("die");
			
		}
	}
}
