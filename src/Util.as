package
{
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	
	public class Util extends FlxU
	{
		
		private static const _assets:Assets = new Assets();
		
		/**
		 * Provides access to all assets according to the current skin setting
		 *  
		 * @return A dictionary from resource name to resource.
		 * 
		 */		
		public static function get assets():Dictionary {
			return _assets.assets[CastleKingdom.SKIN];
		}
		
		/**
		 * Converts the given (x, y) point to a new point containing the indices of the tile at (x, y)
		 * Returns null if the given (x, y) coordinate is off stage.
		 * 
		 * @param cartesian A FlxPoint containing cartesian (x, y) coordinates.
		 * @return A FlxPoint containing tile indices.
		 * 
		 */		
		public static function cartesianToIndices(cartesian:FlxPoint):FlxPoint {
			if (cartesian.x >= FlxG.width && cartesian.y >= FlxG.height) {
				trace("The given coordinates were out of bounds: " + cartesian);
				return null;
			}
			return new FlxPoint(cartesian.x / CastleKingdom.TILE_SIZE, cartesian.y / CastleKingdom.TILE_SIZE);
		}
		
		/**
		 * Converts the given (row, column) point to a new point containing the 
		 * cartesian coordinates of the upper left corner of the specified tile.
		 * Returns null if the given indices are off stage.
		 * 
		 * @param indices A flxpoint containing tile (row, column) tile indices
		 * @return Cartesian coordinates cooresponding to the upper left corner of the specified tile.
		 * 
		 */		
		public static function indicesToCartesian(indices:FlxPoint):FlxPoint {
			if (indices.x > CastleKingdom.TILEMAP_WIDTH || indices.y > CastleKingdom.TILEMAP_HEIGHT) {
				trace("Given indices were out of bounds: " + indices);
				return null;
			}
			return new FlxPoint(indices.x * CastleKingdom.TILE_SIZE, indices.y * CastleKingdom.TILE_SIZE);
		}
		
		/**
		 * Rounds the given point down to the upper left corner of the nearest tile.
		 * 
		 * @param point A FlxPoint containing cartesian coordinates
		 * @return A FlxPoint containing cartesian coordinates rounded down to the nearest upper left corner of a tile
		 * 
		 */		
		public static function roundToNearestTile(point:FlxPoint):FlxPoint {
			return indicesToCartesian(cartesianToIndices(point));
		}
		
		/**
		 * If the current state is an ActiveState the associated castle object is returned, otherwise null is returned.
		 * 
		 * @return the current state's castle object
		 * 
		 */		
		public static function get castle():Castle {
			if (FlxG.state is ActiveState) {
				return (FlxG.state as ActiveState).castle;
			} else {
				trace("Current state is not an ActiveState: " + FlxG.state);
				return null;
			}
		}
		
		/**
		 * 
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return Whether the given (x, y) point is on the stage
		 * 
		 */		
		public static function inBounds(x:Number, y:Number):Boolean {
			return 0 < y && y < FlxG.height && 0 < x && x < FlxG.width;
		}
		
		/**
		 * Centers the given FlxObject with respect to the given parent. 
		 * If parent is null, then it centers the object with respect to the stage.
		 * 
		 * @param obj Any FlxObject
		 * @param parent The parent context of obj
		 * @return A FlxPoint representing the new coordinates of obj
		 * 
		 */		
		public static function center(obj:FlxObject, parent:FlxObject = null):FlxPoint {
			var x:Number = centerX(obj, parent);
			var y:Number = centerY(obj, parent);
			return new FlxPoint(x, y);
		}
		
		/**
		 * Centers the given FlxObject along the x axis with respect to the given parent. 
		 * If parent is null, then it centers the object with respect to the stage.
		 * 
		 * @param obj Any FlxObject
		 * @param parent The parent context of obj
		 * @return A number representing the new x coordinate of obj 
		 * 
		 */		
		public static function centerX(obj:FlxObject, parent:FlxObject = null):Number {
			var max:Number;
			if (parent == null) {
				max = FlxG.width;
			} else {
				max = parent.width;
			}
			var x:Number = max / 2 - obj.width / 2;
			obj.x = x;
			return x;
		}
		
		/**
		 * Centers the given FlxObject along the y axis with respect to the given parent. 
		 * If parent is null, then it centers the object with respect to the stage.
		 * 
		 * @param obj Any FlxObject
		 * @param parent The parent context of obj
		 * @return A number representing the new y coordinate of obj 
		 * 
		 */	
		public static function centerY(obj:FlxObject, parent:FlxObject = null):Number {
			var max:Number;
			if (parent == null) {
				max = FlxG.height;
			} else {
				max = parent.height;
			}
			var y:Number = max / 2 - obj.height / 2;
			obj.y = y;
			return y;
		}
	}
}