package
{
	import org.flixel.FlxSprite;

	/** Unit default behavior:  
	 * 	Moves at default velocity until reaches a target, then stops. 
	 *  When stopped, attacks single target until it dies
	 **/
	public class EnemyUnit extends Unit
	{
		private var _target:Unit;
		
		public function EnemyUnit(x:Number, y:Number, towerID:int) {
			super (x,y,towerID);
		}
		
		/** Moves the character as needed if possible
		 * 
		 * */
		override public function update():void {
			if (contact != null) {
				if(contact.health <= 0) {
					contact = getUnitsInRange()[0];
				}
			}
			velocity = 
			super.update();
		}
		
		/** This function responds to this Unit coming within range of another FlxObject
		 * Sets a single target, only changes it once the current target dies
		 * */
		public function hitRanged(contact:FlxObject, velocity:Number):void {
			if ( contact is DefenseUnit ) {
				this.velocity = 0;
				if(this._target == null || this._target._health <= 0) {
					this._target = contact;
				}
			}
		}
		
		
		
		
	}
}