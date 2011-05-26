package
{
	import org.flixel.*;
	
	public class AttackAnimation extends FlxSprite
	{
		
		private var _target:Unit;
		private var _source:Unit;
		private var _timeout:int;
		
		
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
			_timeout = 10;

		}
		
		override public function update():void {
			_timeout--;
			if(_target != null) {
				this.velocity.y = (_target.y - this.y);
				this.velocity.x = (_target.x - this.x);
				var scale:Number = this.velocity.y / Math.abs(this.velocity.x) ;
				this.velocity.x = 120 * Math.abs(this.velocity.x) / this.velocity.x;
				this.velocity.y = scale * 120;
			}
			if(this.overlaps(_target)) {
				if(_target.inflictDamage(_source.damageDone)){
					_source.thingKilled(_target);
				}
				hitLeft(_target);
			}
			
			if( (this.x < Util.minX || this.x > Util.maxX
				|| this.y > Util.maxY || this.y < Util.minY
				|| !(FlxG.state is AttackState)) || (FlxG.state as AttackState).castle.isGameOver()) {
				hitLeft(_target);
			}
			//_target == null || _target.health <= 0 || 
			if(this.velocity.x > 0) {
				// goes left
				this.facing = LEFT;
			} else {
				// goes right
				this.facing = RIGHT;
			}
		}
		
		public function hitLeft(Contact:Object):void {
			if (!(FlxG.state is AttackState) || (FlxG.state as AttackState).castle.isGameOver() || (Contact == _target  && _timeout < 0) ) {
				(FlxG.state as ActiveState).attackAnims.remove(this);
			}
		}
		
	}
}