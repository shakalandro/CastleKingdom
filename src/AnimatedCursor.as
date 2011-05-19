package
{
	import org.flixel.*;
		
	public class AnimatedCursor extends FlxSprite
	{
		public function AnimatedCursor(pic:Class) {
			super();
			loadGraphic(pic, true, false, 40, 40);
			addAnimation("normal", [0], 1);
			addAnimation("primed", [1], 1);
			addAnimation("attack", [2, 3, 4, 5, 6, 0], 3);
		}
		
		override public function update():void {
			super.update();
			
			play("normal");
			
			x = FlxG.mouse.x;
			y = FlxG.mouse.y;
		}
		
		public function prime():void {
			play("prime");
		}
		
		public function attack():void {
			play("attack");
		}
	}
}