package
{
	import com.facebook.graph.*;
	import com.facebook.graph.data.*;
	
	import flash.events.Event;
	import flash.external.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		private static var _facebookReady:Boolean;
		private static var _facebookUserInfo:Dictionary = new Dictionary();
		private static var _facebookFriends:Object;
		private static var _facebookPics:Dictionary = new Dictionary();
		
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
		 * 
		 * @return Whether we have successfully logged in to Facebook and are ready to query the Graph api.
		 * 
		 */		
		public static function get facebookReady():Boolean {
			return _facebookReady;
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
		public static function cartesianToIndices(cartesian:FlxPoint):FlxPoint {
			if (!Util.inBounds(cartesian.x, cartesian.y)) {
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
		public static function indicesToCartesian(indices:FlxPoint):FlxPoint {
			if (!Util.inTileBounds(indices.x, indices.y)) {
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
		public static function placeOnGround(obj:FlxObject, map:FlxTilemap):Number {
			var x:Number = obj.x + obj.width / 2;
			var indices:FlxPoint = cartesianToIndices(new FlxPoint(x, Util.minY));
			var tileType:int = map.getTile(indices.x, indices.y);
			while (tileType < map.collideIndex && indices.y < map.heightInTiles) {
				indices.y++;
				tileType = map.getTile(indices.x, indices.y);
			}
			var y:Number = Util.indicesToCartesian(indices).y - obj.height;
			obj.y = y
			return y;
		}
		
		
		/**
		 * Super duper logging function for ultimate haxxors only!!!
		 * Logs to Flx.log
		 * Logs to trace
		 * 
		 * Eventually will log to the data base that they are going to set up for us
		 */
		
		public static function superLog(flxLogString:String):void {
			FlxG.log(flxLogString);
			trace(flxLogString);
			// write to the logging data base
		}
		
		/**
		 * Connects to Facebook if possible and tells the callback if it did so. The game must be run from within the
		 * <a href='http://apps.facebook.com/castlekingdom/'>CastleKingdom facebook app page</a> or <a href="24.18.189.178/castlekingdom">my webserver</a> in order to recieve the benefits of the Facebook
		 * API. The user must also select allow on the pop-up that ensues. Ensure that your browser is not supressing this pop-up.
		 * 
		 * @param callback A callback function as a parameter, this function must have the following signature callback(ready:Boolean):void
		 * 
		 */		
		public static function facebookConnect(callback:Function):void {
			Facebook.init(CastleKingdom.FACEBOOK_APP_ID, function(success:Object, fail:Object):void {
				if (!success) {
					superLog("Facebook.init failed: " + success + ", " + fail);
					Facebook.login(function(success:Object, fail:Object):void {
						if (!success) {
							superLog("Facebook.login failed: " + fail);
							Util.facebookConnectListener(callback);
						} else {
							superLog("" + success);
							_facebookReady = true;
						}
						callback(_facebookReady);
					});
				} else {
					superLog("Facebook.init successful: logged in already");
					_facebookReady = true;
					callback(_facebookReady);
				}
			});
		}
		
		/**
		 * This function repeatedly checks the login status until login is successful at which point the callback is called. 
		 * This method makes no effort to achieve login status, it just waits for it to happen. Do not call unless you are sure that successful login is imminent.
		 * 
		 * @param callback A callback function as a parameter, this function must have the following signature callback(ready:Boolean):void
		 * 
		 */		
		private static function facebookConnectListener(callback:Function):void {
			Facebook.getLoginStatus();
			Facebook.addJSEventListener("auth.sessionChange", function(result:Object):void {
				superLog("called");
				if (result.status == "connected") {
					_facebookReady = true;
					superLog("Facebook.getLoginStatus successful: " + result);
					callback(_facebookReady);
					Facebook.removeJSEventListener("auth.sessionChange", this);
				} else {
					superLog("Facebook.getLoginStatus failed: " + result.status);
				}
			});
		}
		
		/**
		 * Returns the FacebookSession object for this user. If Facebook was not initialized properly null is returned instead
		 * 
		 * @return The FacebookSession object for this user.
		 * 
		 */		
		public static function facebookSession():FacebookSession {
			if (_facebookReady) {
				return Facebook.getSession();
			} else {
				superLog("Util.facebookUserInfo: _facbookReady is false");
				return null;
			}
		}
		
		/**
		 * This function retrieves user info from facebook. It stores the results locally so that future calls are fast.
		 * If the user is not logged in this returns null.
		 * 
		 * @param callback A function with the signature callback(info:Object):void
		 * @param forceRefresh Whether to requery facebook for user info.
		 * 
		 */		
		public static function facebookUserInfo(callback:Function, forceRefresh:Boolean = false, uid:String = "me"):void {
			if (!_facebookReady) {
				callback(null);
			} else if (_facebookUserInfo && !forceRefresh) {
				callback(_facebookUserInfo[uid]);
			} else {
				Facebook.api("/" + uid, function(results:Object, fail:Object):void {
					if (results) {
						_facebookUserInfo[uid] = results;
						callback(results);
					} else {
						superLog("Util.facebookUserInfo: failed /" + uid + " " + fail);
					}
				});
			}
		}
		
		/**
		 * facebookConnect must have been called before this method is called, calls the callback with null if not. Provides the callback with a 
		 * list of friends which is a simple object with an id and name field. If justNames is true, then the 
		 * array contains only the string names of each friend. If forceRefresh is false, will return a cached copy of the friends list.
		 * 
		 * @param callback A callback function of the following form callback(friends:Array)
		 * @param justNames Whether the array should contain just names or not
		 * 
		 */		
		public static function facebookFriends(callback:Function, justNames:Boolean = false, forceRefresh:Boolean = false):void {
			function helper(info:Object, justNames:Boolean):Array {
				var friends:Array = info as Array;
				if (justNames) {
					for (var i:int = 0; i < friends.length; i++) {
						friends[i] = friends[i].name;
					}
				}
				return friends;
			}
			if (!_facebookReady) {
				callback(null);	
			} else if (_facebookFriends && !forceRefresh) {
				callback(callback(helper(_facebookFriends, justNames)));	
			} else {
				Facebook.api("/me/friends", function(result:Object, fail:Object):void {
					if (result) {
						_facebookFriends = result;
						callback(helper(_facebookFriends, justNames));
					} else {
						callback(result, fail);
					}
				});
			}
		}
		
		/**
		 * Returns a Class object to the callback that contains the profile pic for the given user. 
		 * Returns a cached version of the image unless otherwise specified. Returns null if facebookReady is false.
		 * 
		 * @param callback A callback with the following signature callback(img:Class):void
		 * @param uid The facebook uid of the desired person
		 * @param forceRefresh Whether to gather the picture from facebook again or use the cached version
		 * 
		 */		
		public static function facebookPic(callback:Function, uid:String = "me", forceRefresh:Boolean = false):void {
			function helper(info:Object):void {
				var url:URLRequest = new URLRequest(info.icon);
				var loader:URLLoader = new URLLoader(url);
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					_facebookPics[uid] = new ExternalImage(e.target.content.bitmapData, e.target.url)
					callback(_facebookPics[uid]);
				});
			}
			if (!_facebookReady) {
				callback(null);	
			} else if (_facebookPics[uid] && !forceRefresh) {
				callback(_facebookPics[uid]);
			} else if (!_facebookUserInfo) {
				Util.facebookUserInfo(helper, false, uid);
			} else {
				helper(_facebookUserInfo);
			}
		}
	}
}

import flash.display.BitmapData;

/**
 * Helper class for loading images from the internet in a flixel loadGraphic compatible way. 
 * @author royman
 * 
 */
class ExternalImage {
	
	private static var data:BitmapData;
	private static var url:String;
		
	public function ExternalImage(bitmapData:BitmapData, id:String):void {
		data = bitmapData;
		url    = id;
	}
		
	public function toString():String {
		return url;
	}
	
	public function get bitmapData():BitmapData {
		return data;
	}
	
}
