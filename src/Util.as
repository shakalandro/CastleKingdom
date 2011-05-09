
package
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	import org.flixel.system.FlxWindow;
	import org.flixel.system.input.Mouse;
	
	/**
	 * This class contains all globally useful helper functions. Coordinate math, database read/write operations and more qualify for inclusion. 
	 * @author royman
	 * 
	 */	
	public class Util extends FlxU
	{		
		private static const _assets:Assets = new Assets();
		
		private var _data:Database;
		
		/**
		 * Provides access to all assets according to the current skin setting
		 *  
		 * @return A dictionary from resource name to resources
		 * 
		 */		
		public static function get assets():Dictionary {
			return _assets.assets[CastleKingdom.SKIN];
		}
		
		public static function get state():GameState {
			return (FlxG.state as GameState);
		}
		
		/**
		 * 
		 * @return The mouse object for this game.
		 * 
		 */		
		public static function get mouse():Mouse {
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
				return (FlxG.state as GameState).header.height;
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
		public static function cartesianToIndices(cartesian:FlxPoint, ignoreX:Boolean = false):FlxPoint {
			if (!Util.inBounds(cartesian.x, cartesian.y) && !ignoreX) {
				trace("The given coordinates were out of bounds: (" + cartesian.x + "," + cartesian.y + ")");
				return null;
			}
			var xIndex:Number = Math.floor((cartesian.x - Util.minX) / CastleKingdom.TILE_SIZE);
			var yIndex:Number = Math.floor((cartesian.y - Util.minY) / CastleKingdom.TILE_SIZE);
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
		public static function indicesToCartesian(indices:FlxPoint, ignoreX:Boolean = false):FlxPoint {
			if (!Util.inTileBounds(indices.x, indices.y) && !ignoreX) {
				trace("Given indices were out of bounds: " + indices);
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
		
		public static function checkClick(obj:FlxObject):Boolean {
			return obj.overlapsPoint(Util.mouse.getScreenPosition(), true);
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
			var x:Number;
			if (parent == null) {
				max = Util.maxX - Util.minX;
				x = (max / 2 - obj.width / 2) + Util.minX;
			} else {
				max = parent.width;
				x = (max / 2 - obj.width / 2) + parent.x;
			}
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
			var y:Number;
			if (parent == null) {
				max = Util.maxY - Util.minY;
				y = (max / 2 - obj.height / 2) + Util.minX;
			} else {
				max = parent.height;
				y = (max / 2 - obj.height / 2) + parent.y;
			}
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
		public static function placeOnGround(obj:FlxObject, map:FlxTilemap = null, ignoreX:Boolean = false, snapX:Boolean = false):Number {
			if (map == null) map = Util.state.map;
			
			var x:Number = obj.x;// + obj.width / 2;
			if ( x < Util.minX) {
				x = Util.minX;
			} else if (x > Util.maxX) {
				x = Util.maxX - CastleKingdom.TILE_SIZE / 2;
			} 
			
			var indices:FlxPoint = cartesianToIndices(new FlxPoint(x, Util.minY), ignoreX);

			var tileType:int = map.getTile(indices.x, indices.y);
			while (tileType < map.collideIndex && indices.y < map.heightInTiles) {
				indices.y++;
				tileType = map.getTile(indices.x, indices.y);
			}
			var coords:FlxPoint = Util.indicesToCartesian(indices, ignoreX);
			var y:Number = coords.y - obj.height;
			obj.y = y;
			if (snapX)  {
				obj.x = coords.x;
			}
			return y;
		}
				
		public static function window(x:Number, y:Number, contents:FlxBasic, closeCallback:Function, title:String = "", bgColor:uint = FlxG.WHITE, 
					padding:Number = 10, width:int = 100, height:int = 100, borderThickness:Number = 3):FlxBasic {
			var window:FlxGroup = new FlxGroup();
			ExternalImage.setData(new BitmapData(width, height, true, bgColor), title);
			var box:FlxSprite = new FlxSprite(x, y, ExternalImage);
			var right:Number = box.width - borderThickness + 1;
			var bottom:Number = box.height - borderThickness + 1;
			box.drawLine(0, 0, right, 0, FlxG.BLACK, borderThickness);
			box.drawLine(right, 0, right, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(right, bottom, 0, bottom, FlxG.BLACK, borderThickness);
			box.drawLine(0, bottom, 0, 0, FlxG.BLACK, borderThickness);
			box.x = x;
			box.y = y;
			window.add(box);
			
			var text:FlxText = new FlxText(x + padding, y, width - padding * 3, title);
			text.color = FlxG.BLACK;
			var close:FlxButton = new FlxButton(x + borderThickness, y + borderThickness	, "Close", function():void {
				if (closeCallback != null) closeCallback();
				window.kill();
			});
			if (contents) {
				if (contents is FlxGroup) {
					for each (var n:FlxBasic in (contents as FlxGroup).members) {
						if (n is FlxObject) {
							(n as FlxObject).x += x + padding;
							(n as FlxObject).y += y + text.height + padding;
						}
					}
				} else {
					(contents as FlxObject).x += x + padding;
					(contents as FlxObject).y += y + text.height + padding;
				}
				window.add(contents);
			}
			window.add(close);
			text.x += close.width;
			window.add(text);
			for each(var m:FlxBasic in window.members) {
				if (m is FlxObject) {
					(m as FlxObject).allowCollisions = FlxObject.NONE;
				}
			}
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
		
		public static function logObj(message:String = "", ...args:Array):void {
			var s:String = message;
			if (s != "") {
				s += "\n";
			}
			if (args.length > 0) {
				s += "\t" + typeof(args[0]) + ": \n";
				for (var prop:String in args[0]) {
					s += "\t\t" + prop + ": " + args[0][prop] + "\n";
				}
			}
			for (var j:int = 1; j < args.length; j++) {
				s += "\t" + typeof(args[j]) + ": \n";
				for (var props:String in args[j]) {
					s += "\t\t" + props + ": " + args[j][props] + "\n";
				}
			}
			FlxG.log(s);
			trace(s);
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
		
		public static function getKnownFriends(callback:Function):void {
			FaceBook.friends(function(friends:Array):void {
				
			});
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
		
