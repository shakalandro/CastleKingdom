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
			Facebook.init(CastleKingdom.FACEBOOK_APP_ID, function(success:Object, fail:Object):void {
				if (!success) {
					Util.log("Facebook.init failed: " + success + ", " + fail);
					Facebook.login(function(success:Object, fail:Object):void {
						if (!success) {
							Util.log("Facebook.login failed: " + fail);
							FaceBook.connectListener(callback);
						} else {
							Util.log("" + success);
							_facebookReady = true;
						}
						callback(_facebookReady);
					});
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
			Facebook.addJSEventListener("auth.sessionChange", function(result:Object):void {
				Util.log("called");
				if (result.status == "connected") {
					_facebookReady = true;
					Util.log("Facebook.getLoginStatus successful: " + result);
					callback(_facebookReady);
					Facebook.removeJSEventListener("auth.sessionChange", this);
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
			} else if (_facebookUserInfo[uid] && !forceRefresh) {
				callback(_facebookUserInfo[uid]);
			} else {
				Facebook.api("/" + uid, function(results:Object, fail:Object):void {
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
		public static function friends(callback:Function, justNames:Boolean = false, forceRefresh:Boolean = false):void {
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
				callback(helper(_facebookFriends, justNames));	
			} else {
				Facebook.api("/me/friends", function(result:Object, fail:Object):void {
					if (result) {
						_facebookFriends = result;
						callback(helper(_facebookFriends, justNames));
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
		 * @param The size of the image to gather. ['small' | 'normal' | 'large']
		 * 
		 */		
		public static function picture(callback:Function, uid:String = "me", forceRefresh:Boolean = false, size:String = "small"):void {
			function helper(info:String):void {
				var url:URLRequest = new URLRequest(info);
				var context:LoaderContext = new LoaderContext(true);
				context.securityDomain = SecurityDomain.currentDomain;
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
					ExternalImage.setData(e.target.content.bitmapData, e.target.url);
					_facebookPics[uid] = new ExternalImage();
					callback(ExternalImage);
				});
				loader.load(url, context);
			}
			if (!_facebookReady) {
				Util.log("Util.facebookPic failed: facebookReady is false");
				callback(null);
			} else if (_facebookPics[uid] && !forceRefresh) {
				ExternalImage.setData(_facebookPics[uid].bitmapData, _facebookPics[uid].url);
				callback(ExternalImage);
			} else if (uid == "me"){
				FaceBook.userInfo(function(result:Object):void {
					helper(Facebook.getImageUrl(result.id, size));
				});
			} else {
				helper(Facebook.getImageUrl(uid, size));
			}
		}
		
		public static function get uid():Number {
			if (_facebookReady) {
				return parseInt(FaceBook.session().uid);
			} else {
				return NaN;
			}
		}
	}
}