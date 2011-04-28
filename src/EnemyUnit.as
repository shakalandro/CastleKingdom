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
		
		public function EnemyUnit(x:Number, y:Number, towerID:int) {
			
			super (x,y,towerID);
			this._type = Unit.GROUND;
			
			this.speed = 10;
			this.velocity.x = speed;
			this.loadGraphic(Util.assets[Assets.SWORDSMAN],true,true,23,23,true);
			this.addAnimation("walk", [0,1,2,3],speed/2,true);
			this.addAnimation("attack",[4,5,6,7],_rate*2,true);
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
			
			
		}
		
		
		
		
		/** Moves the character as needed if possible
		 * 
		 */
		override public function update():void {
			/*if (contact != null) {
				if(contact.health <= 0) {
					contact = getUnitsInRange()[0];
				}
			}*/
			if (type == Unit.GROUND && this.y <= Util.castle.y ){
				this.velocity.y = 0 ;
			}
			// Corrects facing/movement
			if(this.x > Util.maxX/2) {
				// goes left
				this.velocity.x = -speed;
				this.facing = LEFT;
			} else {
				// goes right
				this.velocity.x = speed;
				this.facing = RIGHT;
				
				
			}
			
			super.update();
			
		}
		
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * Sets a single target, only changes it once the current target dies
		 * */
		
		override public function hitRanged(contact:FlxObject, velocity:Number):void {
			if ( contact is DefenseUnit ) {
				this.velocity.x = 0;
				this.velocity.y = 0;
				if(this._target == null || this._target.health <= 0) {
					this._target = contact as Unit;
				}
				this.play("attack");
			} 
			if ( contact is Castle ) {
				// Either disappear, climb, or ?? 
				this.play("attack");

			} else {}
		}
		
		
		
		override public function destroy():void {
			this.color =  0x112233; 
		//	this.velocity.x = 0;
		//	play("die");
			
		}
		
	}
}
