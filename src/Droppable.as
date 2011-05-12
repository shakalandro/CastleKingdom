package
{
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;

	public interface Droppable
	{
		function get canDrop():Boolean;
		function set canDrop(t:Boolean):void;
		function get boundingSprite():FlxSprite;
		/**
		 * Attempt to drop obj onto this object. If true is returned then obj was accepted otherwise obj was not accepted.
		 * 
		 * @param obj The dropped FlxObject
		 * @param oldX The old x position of obj
		 * @param oldY The old y position of obj
		 * @return Whether the drop was accepted or not
		 * 
		 */		
		function dropOnto(obj:FlxObject, oldX:Number, oldY:Number):Boolean;
	}
}