package
{
	import org.flixel.*;
	
	public class Util extends FlxU
	{
		public function Util()
		{
			super();
		}
		
		/**
		 * Converts the given (x, y) point to a new point containing the indices of the tile at (x, y)
		 * Returns null if the given (x, y) coordinate is off stage.
		 * 
		 * @param cartesian A FlxPoint containing cartesian (x, y) coordinates.
		 * @return A FlxPoint containing tile indices.
		 * 
		 */		
		public static function cartesianToIndexes(cartesian:FlxPoint):FlxPoint {
			if (cartesian.x >= FlxG.width && cartesian.y >= FlxG.height) {
				return null;
			}
			return new FlxPoint(cartesian.x / CastleKingdom.TILE_SIZE, cartesian.y / CastleKingdom.TILE_SIZE);
		}
		
		/**
		 * If the current state is an ActiveState the associated castle object is returned, otehrwise null is returned.
		 * 
		 * @return the current state's castle object
		 * 
		 */		
		public static function get castle():Castle {
			if (FlxG.state is ActiveState) {
				return (FlxG.state as ActiveState).castle;
			} else {
				return null;
			}
		}
		
		public static function inBounds(x:Number, y:Number):Boolean {
			return 0 < y && y < FlxG.height && 0 < x && x < FlxG.width;
		}
	}
}