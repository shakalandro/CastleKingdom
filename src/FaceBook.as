package
{
	import com.facebook.graph.*;
	import com.facebook.graph.data.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	
	/**
	 * A collection of easy functionf for getting information from Facebook 
	 * @author royman
	 * 
	 */	
	public class FaceBook
	{
		private static var _facebookReady:Boolean;
		private static var _facebookUserInfo:Dictionary = new Dictionary();
		private static var _facebookFriends:Object;
		private static var _facebookPics:Dictionary = new Dictionary();
		
		/**
		 * 
		 * @return Whether we have successfully logged in to Facebook and are ready to query the Graph api.
		 * 
		 */		
		public static function get facebookReady():Boolean {
			return _facebookReady;
		}
		
		/**
		 * Connects to Facebook if possible and tells the callback if it did so. The game must be run from within the
		 * <a href='http://apps.facebook.com/castlekingdom/'>CastleKingdom facebook app page</a> or <a href="24.18.189.178/castlekingdom">my webserver</a> in order to recieve the benefits of the Facebook
		 * API. The user must also select allow on the pop-up that ensues. Ensure that your browser is not supressing this pop-up.
		 * 
		 * @param callback A callback function as a parameter, this function must have the following signature callback(ready:Boolean):void
		 * 
		 */		
		public static function connect(callback:Function, accessToken:String = null):void {
			(FlxG.state as GameState).loading = true;
			Facebook.init(CastleKingdom.FACEBOOK_APP_ID, function(success:Object, fail:Object):void {
				(FlxG.state as GameState).loading = false;
				if (!success) {
					Util.log("Facebook.init failed: " + success + ", " + fail);
					Facebook.login(function(success:Object, fail:Object):void {
						if (!success) {
							Util.log("Facebook.login failed: " + fail);
							FaceBook.connectListener(callback);
						} else {
							_facebookReady = true;
						}
						callback(_facebookReady);
					}, ["publish_stream"]);
				} else {
					Util.log("Facebook.init successful: logged in already");
					_facebookReady = true;
					callback(_facebookReady);
				}
			}, null, accessToken);
		}
		
		/**
		 * This function repeatedly checks the login status until login is successful at which point the callback is called. 
		 * This method makes no effort to achieve login status, it just waits for it to happen. Do not call unless you are sure that successful login is imminent.
		 * 
		 * @param callback A callback function as a parameter, this function must have the following signature callback(ready:Boolean):void
		 * 
		 */		
		private static function connectListener(callback:Function):void {
			(FlxG.state as GameState).loading = true;
			Facebook.addJSEventListener("auth.sessionChange", function(result:Object):void {
				(FlxG.state as GameState).loading = false;
				Util.log("called");
				if (result.status == "connected") {
					_facebookReady = true;
					Util.log("Facebook.getLoginStatus successful: " + result);
					Facebook.removeJSEventListener("auth.sessionChange", this);
					callback(_facebookReady);
				} else {
					Util.log("Facebook.getLoginStatus failed: " + result.status);
				}
			});
			Facebook.getLoginStatus();
		}
		
		/**
		 * Returns the FacebookSession object for this user. If Facebook was not initialized properly null is returned instead
		 * 
		 * @return The FacebookSession object for this user.
		 * 
		 */		
		public static function session():FacebookSession {
			if (_facebookReady) {
				Util.logObj("User Object in session()", Facebook.getSession().user);
				return Facebook.getSession();
			} else {
				Util.log("Util.facebookUserInfo: _facbookReady is false");
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
		public static function userInfo(callback:Function, forceRefresh:Boolean = false, uid:String = "me"):void {
			if (!_facebookReady) {
				Util.log("Util.facebookUserInfo: _facebookReady = false");
				callback(null);
			} else if (!forceRefresh && _facebookUserInfo[uid]) {
				Util.log("Util.facebookUserInfo: cached copy returned (" + uid + "): ");
				Util.logObj("_facebookUserInfo[uid]:", _facebookUserInfo[uid]);
				callback(_facebookUserInfo[uid]);
			} else {
				(FlxG.state as GameState).loading = true;
				Facebook.api("/" + uid, function(results:Object, fail:Object):void {
					(FlxG.state as GameState).loading = false;
					if (results) {
						_facebookUserInfo[uid] = results;
						callback(results);
					} else {
						Util.log("Util.facebookUserInfo: failed /" + uid + " " + fail);
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
		public static function friends(callback:Function, forceRefresh:Boolean = false):void {
			if (!_facebookReady) {
				callback(null);	
			} else if (_facebookFriends && !forceRefresh) {
				callback(_facebookFriends as Array);	
			} else {
				(FlxG.state as GameState).loading = true;
				Facebook.api("/me/friends", function(result:Object, fail:Object):void {
					(FlxG.state as GameState).loading = false;
					if (result) {
						_facebookFriends = result;
						callback(_facebookFriends as Array);
					} else {
						callback(result);
					}
				});
			}
		}
		
		/**
		 * Returns a Class object to the callback that contains the profile pic for the given user. 
		 * Returns a cached version of the image unless otherwise specified. Returns null if facebookReady is false.
		 * The Class object given to the callback must be instantiated by a FlxSprite 
		 * before the next call to this function in order to operate properly. This means you cannot store the Class parameters.
		 * 
		 * @param callback A callback with the following signature callback(img:Class):void
		 * @param uid The facebook uid of the desired person
		 * @param forceRefresh Whether to gather the picture from facebook again or use the cached version
		 * @param The size of the image to gather. ['square' | 'small' | 'normal' | 'large']
		 * 
		 */		
		public static function picture(callback:Function, uid:String = "me", forceRefresh:Boolean = false, size:String = "square"):void {
			function helper(info:String):void {
				var url:URLRequest = new URLRequest(info);
				var context:LoaderContext = new LoaderContext(true);
				context.securityDomain = SecurityDomain.currentDomain;
				var loader:Loader = new Loader();
				(FlxG.state as GameState).loading = true;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					(FlxG.state as GameState).loading = false;
					_facebookPics[uid] = e.target.content.bitmapData;
					ExternalImage.setData(_facebookPics[uid], uid);
					callback(ExternalImage);
				});
				loader.load(url, context);
			}
			if (!_facebookReady) {
				Util.log("Util.facebookPic failed: facebookReady is false");
				callback(null);
			} else if (_facebookPics[uid] && !forceRefresh) {
				ExternalImage.setData(_facebookPics[uid], uid);
				var ext:ExternalImage = new ExternalImage();
				callback(ExternalImage);
			} else if (uid == "me" && !forceRefresh){
				FaceBook.userInfo(function(result:Object):void {
					helper(Facebook.getImageUrl(result.id, size));
				});
			} else {
				helper(Facebook.getImageUrl(uid, size));
			}
		}
		
		/**
		 * Returns the name of the person with the id of id. Returns null if the id does not belong 
		 * to the user or anyone in the user's friend's list. 
		 * 
		 * @param id An id to look up
		 * @param callback A function with the signature callback(name:String):void.
		 * 
		 */		
		public static function getNameByID(id:String, callback:Function):void {
			if (id == FaceBook.uid + "" || id == "me") {
				callback(FaceBook.name);
			} else {
				(FlxG.state as GameState).loading = true;
				FaceBook.friends(function(friends:Array):void {
					(FlxG.state as GameState).loading = false;
					var found:String = null;
					for each(var friend:Object in friends) {
						if (friend.id + "" == id + "") {
							found = friend.name;
							break;
						}
					}
					callback(friend.name);
				}, false);
			}
		}
		
		/**
		 * Calls the callback with an array of prefilled FlxSprite objects at coordinate (0, 0). 
		 * @param ids A list of facebook ids to get the pictures of
		 * @param callback A callback with teh signature callback(sprites:Array):void
		 * @param border Whether to draw on a border to the image
		 * 
		 */		
		public static function getAllPictures(ids:Array, callback:Function, border:Boolean = true):void {
			getAllPicturesHelper(ids, callback, [], border);
		}
		
		private static function getAllPicturesHelper(ids:Array, callback:Function, result:Array, border:Boolean, borderThickness:Number = 3):void {
			if (ids.length == 0) {
				callback(result);
			} else {
				var id:String = ids[0].id || ids[0];
				(FlxG.state as GameState).loading = true;
				FaceBook.picture(function(pic:Class):void {
					(FlxG.state as GameState).loading = false;
					var picSprite:FlxSprite = new FlxSprite(0, 0, pic);
					Util.drawBorder(picSprite);
					result.push(picSprite);
					FaceBook.getAllPicturesHelper(ids.slice(1, ids.length), callback, result, border);
				}, id);
			}
		}
		
		public static function post(fromUID:String, toUID:String, _message:String, callback:Function):void {
			var _params:Object = new Object();
			
			_params = {
				access_token: Facebook.getSession().accessToken,
				message: _message,
				from: fromUID,
				to: toUID,
				link: Util.assets[Assets.GAME_URL]
			};
			
			Facebook.api("/" + toUID + "/feed", callback, _params, "POST");
		}
		
		public static function postOnWall(callback:Function, fromUID:String, toUID:String, message:String):void {
			Facebook.postData("blah", callback, {
				uid: fromUID,
				target_id: toUID,
				link: "http://google.com"
			});
		}
		
		/**
		 * Gives you the uid of the current user. Results are unspecified if !FACEBOOK_ON. 
		 * @return The facebook uid of the currently logged in user
		 * 
		 */		
		public static function get uid():String {
			if (_facebookReady) {
				return FaceBook.session().uid;
			} else {
				return null;
			}
		}
		
		public static function get name():String {
			if (_facebookReady && _facebookUserInfo["me"]) {
				return _facebookUserInfo["me"].name;
			} else {
				return null;
			}
		}
	}
}