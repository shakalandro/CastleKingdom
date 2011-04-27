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
		
		public static const FLYING:String = "fly"; 
		public static const LAND:String = "land"; 
		public static const UNDERGROUND:String = "mole"; 
		
		public function EnemyUnit(x:Number, y:Number, towerID:int) {
			super (x,y,towerID);
			
		}
		
		/** Moves the character as needed if possible
		 * 
		 * */
		/*
		override public function update():void {
			if (contact != null) {
				if(contact.health <= 0) {
					contact = getUnitsInRange()[0];
				}
			}
			velocity = 
			super.update();
		}
		*/
		/** This function responds to this Unit coming within range of another FlxObject
		 * Sets a single target, only changes it once the current target dies
		 * */
		/*
		override public function hitRanged(contact:FlxObject, velocity:Number):void {
			if ( contact is DefenseUnit ) {
				this.velocity = 0;
				if(this._target == null || this._target._health <= 0) {
					this._target = contact;
				}
			}
		}
		*/
	}
}