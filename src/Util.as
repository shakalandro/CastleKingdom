package
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	import org.flixel.data.FlxMouse;
	
	/**
	 * This class contains all globally useful helper functions. Coordinate math, database read/write operations and more qualify for inclusion. 
	 * @author royman
	 * 
	 */	
	public class Util extends FlxU
	{		
		private static const _assets:Assets = new Assets();
		
		/**
		 * Provides access to all assets according to the current skin setting
		 *  
		 * @return A dictionary from resource name to resources
		 * 
		 */		
		public static function get assets():Dictionary {
			return _assets.assets[CastleKingdom.SKIN];
		}
		
		/**
		 * 
		 * @return The mouse object for this game.
		 * 
		 */		
		public static function get mouse():FlxMouse {
			return FlxG.mouse;
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
		 * @return The minimum cartesian x coordinate of the playable map area
		 * 
		 */		
		public static function get minX():Number {
			return 0;
		}
		
		/**
		 * 
		 * @return The minimum cartesian y coordinate of the playable map area
		 * 
		 */		
		public static function get minY():Number {
			if (FlxG.state is GameState) {
				return (FlxG.state as GameState).hud.height;
			} else {
				return 0;
			}
		}
		
		/**
		 * 
		 * @return The maximum cartesian x coordinate of the playable map area
		 * 
		 */		
		public static function get maxX():Number {
			return FlxG.width;
		}
		
		/**
		 * 
		 * @return The maximum cartesian y coordinate of the playable map area
		 * 
		 */		
		public static function get maxY():Number {
			return FlxG.height;
		}
		
		/**
		 * 
		 * @return The maximum horizontal tile index of the map
		 * 
		 */		
		public static function get maxTileX():Number {
			return CastleKingdom.TILEMAP_WIDTH;
		}
		
		/**
		 * 
		 * @return The minimum horizontal tile index of the map
		 * 
		 */		
		public static function get minTileX():Number {
			return 0;
		}
		
		/**
		 * 
		 * @return The maximum vertical tile index of the map
		 * 
		 */		
		public static function get maxTileY():Number {
			return CastleKingdom.TILEMAP_HEIGHT;
		}
		
		/**
		 * 
		 * @return The minimum vertical tile index of the map
		 * 
		 */		
		public static function get minTileY():Number {
			return 0;
		}
		
		/**
		 * Converts the given (x, y) point to a new point containing the indices of the tile at (x, y)
		 * Returns null if the given (x, y) coordinate is off stage.
		 * 
		 * @param cartesian A FlxPoint containing cartesian (x, y) coordinates.
		 * @return A FlxPoint containing tile indices.
		 * 
		 */		
		public static function cartesianToIndices(cartesian:FlxPoint, ignoreBounds:Boolean = false):FlxPoint {
			if (!Util.inBounds(cartesian.x, cartesian.y) && !ignoreBounds) {
				trace("The given coordinates were out of bounds: " + cartesian);
				return null;
			}
			
			var xIndex:Number = (cartesian.x - Util.minX) / CastleKingdom.TILE_SIZE;
			var yIndex:Number = (cartesian.y - Util.minY) / CastleKingdom.TILE_SIZE;
			return new FlxPoint(xIndex, yIndex);
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
		public static function indicesToCartesian(indices:FlxPoint, ignoreBounds:Boolean = false):FlxPoint {
			if (!Util.inTileBounds(indices.x, indices.y) && !ignoreBounds) {
				trace("Given indices were out of bounds: " + indices + ", ignore = " + ignoreBounds);
				return null;
			}
			
			return new FlxPoint(indices.x * CastleKingdom.TILE_SIZE + Util.minX, indices.y * CastleKingdom.TILE_SIZE + Util.minY);
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
		 * Checks whether the given coordinates are valid coordinates within the playable game field.
		 * 
		 * @param x A cartesian x coordinate
		 * @param y A cartesian y coordinate
		 * @return Whether the given (x, y) point is on the stage
		 * 
		 */		
		public static function inBounds(x:Number, y:Number):Boolean {
			return x >= Util.minX && x < Util.maxX && y >= Util.minY && y < Util.maxY;
		}
		
		/**
		 * Checks whether the given indices are valid indices within the map.
		 * 
		 * @param x A tilemap x index
		 * @param y A tilemap y index
		 * @return Whether the given (x, y) indices exist in the map
		 * 
		 */		
		public static function inTileBounds(x:Number, y:Number):Boolean {
			return x >= Util.minTileX && x < Util.maxTileX && y >= Util.minTileY && y < Util.maxTileY;
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
				max = Util.maxX - Util.minX;
			} else {
				max = parent.width;
			}
			var x:Number = (max / 2 - obj.width / 2) + Util.minX;
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
				max = Util.maxY - Util.minY;
			} else {
				max = parent.height;
			}
			var y:Number = (max / 2 - obj.height / 2) + Util.minX;
			obj.y = y;
			return y;
		}
		
		/**
		 * Sets the given objects y coordinate such that the object sits on top of the 
		 * topmost piece of solid terrain that is underneath the horizontal center of the object.
		 * 
		 * @param obj The FlxObject to be placed
		 * @param map The FlxTilemap the object is to be placed on
		 * @return The y coordinate of where the object was placed with respect to the stage.
		 * 
		 */		
		public static function placeOnGround(obj:FlxObject, map:FlxTilemap, ignoreCenter:Boolean = false):Number {
			
			
			var x:Number = obj.x + obj.width / 2;
			
			// Fixes unit drop problem
			if(ignoreCenter) {
				x -= obj.width / 2;
				if( x > Util.maxX /2) {
					x = Util.maxX - 10; // keeps on screen but places near edge
				} else if ( x < Util.maxX / 2 ){
					x = Util.minX - 22; // tries to start unit picture off edge of screen
				} 
			}
			
			
			
			
			
			var indices:FlxPoint = cartesianToIndices(new FlxPoint(x, Util.minY), true);
			var tileType:int = map.getTile(indices.x, indices.y);
			while (tileType < map.collideIndex && indices.y < map.heightInTiles) {
				indices.y++;
				tileType = map.getTile(indices.x, indices.y);
			}
			var y:Number = Util.indicesToCartesian(indices, true).y - obj.height;
			obj.y = y
			return y;
		}
		
		public static function window(x:Number, y:Number, contents:FlxObject, title:String = "", 
									  bgColor:uint = 0xffffffff, padding:Number = 10, closable:Boolean = true, width:Number = -1, height:Number = -1):FlxObject {
			if (width == -1) {
				width = contents.width + padding * 2;
			}
			if (height == -1) {
				height = contents.height + padding * 4;
			}
			var window:FlxGroup = new FlxGroup();
			window.x = x;
			window.y = y;
			ExternalImage.setData(new BitmapData(width, height, true, bgColor), title);
			var box:FlxSprite = new FlxSprite(x, y, ExternalImage);
			var text:FlxText = new FlxText(x + padding * 2, y, width - padding * 3, title);
			window.add(box);
			contents.x = x + padding;
			contents.y = y + padding * 3;
			window.add(contents);
			if (closable) {
				var close:FlxButton = new FlxButton(x, y, function():void {
					window.kill();
				});
				close.width = 20;
				var btnText:FlxText = new FlxText(0, 0, 10, "X");
				close.loadText(btnText);
				window.add(close);
			}
			window.add(text);
			return window;
		}
		
		/**
		 * Super duper logging function for ultimate haxxors only!!!
		 * Logs to Flx.log
		 * Logs to trace
		 * 
		 * Eventually will log to the data base that they are going to set up for us
		 */
		
		public static function log(...args:Array):void {
			var s:String = "";
			if (args.length != 0) {
				s += args[0];
			}
			for (var i:int = 1; i < args.length; i++) {
				s += ", " + args[i];
			}
			FlxG.log(s);
			trace(s);
			// write to the logging data base
		}
		
		/**
		 * A handy function for iterating over a array of objects while maintaining a closure.
		 * Calls f with each of the objects in stuff as its parameter.
		 * Allows us to make asynchronous calls while iterating over an array of objects.
		 * Inserts an 'i' property into each of the objects given to f for use as a loop variable if needed.
		 *  
		 * @param stuff An array of Objects
		 * @param f A function to apply to each Object in stuff. f should have the following signature f(thing:Object)
		 * 
		 */		
		public static function forEach(stuff:Array, f:Function):void {
			for (var i:int = 0; i < stuff.length; i++) {
				new Closure(stuff[i]).eval(f, i);
			}
		}
	}
}

/**
 * A helper class for fixing the closure issue when making asynchronous calls across a collection. 
 * @author royman
 * 
 */
class Closure {
	private var _context: Object;
	
	public function Closure(context:Object) {
		_context = context;
	}
	
	public function eval(f:Function, index:Number): void {
		f(_context, index);
	}
}

