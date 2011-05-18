package
{
	import org.flixel.*;
	
	public class AttackAnimation extends FlxSprite
	{
		
		private var _target:Unit;
		private var _source:Unit;
		
		
		
		public function AttackAnimation(X:Number=0, Y:Number=0, target:Unit = null, source:Unit = null, type:String = "Arrow" )
		{
			super(X, Y, null);
			this._target = target;
			var imgResource:Class = Util.assets[type];
			this.loadGraphic(imgResource,false,true);
			(FlxG.state as ActiveState).attackAnims.add(this);
			this.immovable = true;
			this.allowCollisions = 0;
			_source = source;

		}
		
		override public function update():void {
			this.velocity.y = (_target.y - this.y);
			this.velocity.x = (_target.x - this.x);
			var scale:Number = this.velocity.y / Math.abs(this.velocity.x) ;
			this.velocity.x = 200 * Math.abs(this.velocity.x) / this.velocity.x;
			this.velocity.y = scale * 200;
			if(this.overlaps(_target) ) {
				trace( "Found dude: " + _target.health + " / " + _target.maxHealth);
				if(_target.inflictDamage(_source.damageDone)){
					trace("Dealt " + _source.damageDone + " damage to " + _target.health + " / " + _target.maxHealth + " dude");
					_source.thingKilled(_target);
				}
				hitLeft(_target);
			}
			
			if(_target == null || _target.health <= 0 || !(FlxG.state is AttackState) || (FlxG.state as AttackState).castle.isGameOver()) {
				hitLeft(_target);
			}
			if(this.velocity.x > 0) {
				// goes left
				this.facing = LEFT;
			} else {
				// goes right
				this.facing = RIGHT;
			}
		}
		
		public function hitLeft(Contact:Object):void {
			if (Contact == _target) {
				(FlxG.state as ActiveState).attackAnims.remove(this);
			}
		}
		
	}
}