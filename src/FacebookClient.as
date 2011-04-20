package facebook
{
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.events.HTTPStatusEvent;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.events.EventDispatcher;
	import flash.events.TextEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.getQualifiedClassName;
	import flash.accessibility.Accessibility;
	import flash.display.Sprite;
	
	
	/**
	 * The class that can be used to invoke requests against the 
	 * Facebook API.  To use, instantiate a new FacebookClient
	 * object passing in:
	 * <ul>
	 *   <li>API Key - The key that is provided by facebook when a new application is created
	 *   <li>Secret - The secret that is provided by facebook when a new application is created
	 *   <li>Session key - A session key that is valid for your application.  You can obtain this
	 *    via an infinite session key, or by having the user log in and then pass the session key
	 *    via flashvars.
	 * </ul>
	 * 
	 * Once you have created a client, do
	 * <i>
	 * 			var fb:FacebookClient = new FacebookClient(myAPIKey, mySecret, mySessionKey);
	 * 			fb.addEventListener(FacebookRequestEvent.CALL_RESULT_EVENT, onRequestComplete);
	 * 			fb.[invoke method]. E.g., fb. 			fb.users_getLoggedInUser();
	 * </i>
	 * 
	 * Your result handler will be called with the results from the call to Facebook's REST interface.
	 * The succcess property on the FAcebookRequestEvent object indicates whether or not the call was
	 * successful.  If it was, then the 'result' property on the event contains the returned XML from
	 * facebook and e4x can be used to access the properties. Otherwise, the failureMessage property
	 * will indicate why the call failed. 
	 * 
	 * <p/>Note: There is only a single method in this class that does any real work: invokeMethod().
	 * All other methods are simple wrappers around this function and are self documenting via their
	 * signature.  If any method is exposed by facebook that is not included in this class simply use
	 * the invokeMethod() to access it.
	 */
	[Event(name="facebookResult", type="facebook.FacebookRequestEvent")]
	public class FacebookClient
		extends EventDispatcher
	{
		
		/**********************************************************************
		 * 
		 *  Member variables
		 * 
		 * ********************************************************************/
		protected var mAPIKey:String;
		protected var mSecret:String;
		protected var mSessionKey:String;
		protected var mResponse:XML;
		
		protected const REST_SERVER_URL:String = "http://api.facebook.com/restserver.php";
		
		
		/**********************************************************************
		 * 
		 *  Constructor
		 * 
		 * ********************************************************************/
		
		/**
		 * Used to create an instance of the FacebookClient that can be used for
		 * a single call.  
		 *
		 * @param pAPIKey your api key, provided by	facebook
		 * @param pSecret your secret, provided by facebook
		 * @param pSessionKey the session key, obtained for a specific session
		 */					
		public function FacebookClient(pAPIKey:String, pSecret:String, pSessionKey:String):void {
			mSessionKey = pSessionKey;
			mAPIKey = pAPIKey;
			mSecret = pSecret;
		}
		
		/**********************************************************************
		 * 
		 *  Methods
		 * 
		 * ********************************************************************/
		
		// AUTH RELATED FUNCTIONS
		
		public function auth_getSession(pAuthToken:String):void {
			var params:Array = new Array();
			params['authToken'] = pAuthToken;
			invokeMethod('facebook.auth.getSession', params);
		}
		
		// FEED RELATED FUNCTIONS
		/**
		 * Publishes a story to a users news feed.  The response from this will be '0' for failure
		 * or '1' if the call succeeds.  To check the success/failure:
		 * 
		 * var result:XML = pEvent.result;
		 *	trace(result.fb::feed_publishStoryToUser_response_elt);
		 * this will give a 0 or 1.
		 */
		public function feed_publishStoryToUser(pTitle:String, pBody:String, pImage1:String='', pImage1Link:String='', pImage2:String='', 
												pImage2Link:String='', pImage3:String='', pImage3Link:String='', pImage4:String='', 
												pImage4Link:String='', pPriority:int=1):void 
		{
			var params:Array = new Array();
			params['title'] = pTitle;
			params['image_1'] = pImage1;
			params['image_1_link'] = pImage1Link;
			params['image_2'] = pImage2;
			params['image_2_link'] = pImage2Link;
			params['image_3'] = pImage3;
			params['image_3_link'] = pImage3Link;
			params['image_4'] = pImage4;
			params['image_4_link'] = pImage4Link;
			params['priority'] = pPriority;
			invokeMethod('facebook.feed.publishStoryToUser', params);		 		
		}
		
		/**
		 * Publishes a story to a users news feed.  The response from this will be '0' for failure
		 * or '1' if the call succeeds.  To check the success/failure:
		 * 
		 * var result:XML = pEvent.result;
		 *	trace(result.fb::feed_publishActionOfUser_response_elt);
		 * this will give a 0 or 1.
		 */
		public function feed_publishActionOfUser(pTitle:String, pBody:String, pImage1:String='', pImage1Link:String='', pImage2:String='', 
												 pImage2Link:String='', pImage3:String='', pImage3Link:String='', pImage4:String='', 
												 pImage4Link:String='', pPriority:int=1):void 
		{
			var params:Array = new Array();
			params['title'] = pTitle;
			params['image_1'] = pImage1;
			params['image_1_link'] = pImage1Link;
			params['image_2'] = pImage2;
			params['image_2_link'] = pImage2Link;
			params['image_3'] = pImage3;
			params['image_3_link'] = pImage3Link;
			params['image_4'] = pImage4;
			params['image_4_link'] = pImage4Link;
			params['priority'] = pPriority;
			invokeMethod('facebook.feed.publishActionOfUser', params);		 		
		}		 
		
		// FQL RELATED FUNCTIONS
		/**
		 *  Executes a fql query and returns the results.  The results are in table/column form and can be parsed
		 * as such.  E.g., executing the query:
		 * 
		 *	fb.fql_query("select first_name from user where uid = 7264333230");
		 * 
		 * could be parsed via (user is the table, first_name the column):
		 * 
		 * var result:XML = pEvent.result;
		 * trace(result.fb::user.fb::first_name);
		 */
		public function fql_query(pQuery:String):void {
			var params:Array = new Array();
			params['query'] = pQuery;
			invokeMethod('facebook.fql.query', params);
		}
		
		// FRIEND RELATED FUNCTIONS
		/**
		 * Determines whether or not two friends listed by their UIDs are friends.  The
		 * result is 0 for false or 1 for true.  To parse the results:
		 * 
		 * 
		 * var result:XML = pEvent.result;
		 * trace(result.fb::friend_info.fb::are_friends);
		 * this will give a 0 or 1.
		 */
		public function friends_areFriends(pUser1:String, pUser2:String):void {
			var params:Array = new Array();
			params['uids1'] = pUser1;
			params['uids2'] = pUser2;
			invokeMethod('facebook.friends.areFriends', params);
		}
		
		/**
		 * Get a list of friends for the user associated with the current session.
		 * The list of friends are returned as a list of UIDs.  To parse the results:
		 * 
		 * var result:XML = pEvent.result;
		 * for each (var uid:XML in result.uid) {}
		 */
		public function friends_get():void {
			invokeMethod('facebook.friends.get', new Array());
		}
		
		
		/**
		 * Get a list of friends for the user associated with the current session who
		 * are users of this application.
		 * The list of friends are returned as a list of UIDs.  To parse the results:
		 * 
		 * var result:XML = pEvent.result;
		 * for each (var uid:XML in result.uid) {}
		 */				 
		public function friends_getAppUsers():void {
			invokeMethod('facebook.friends.getAppUsers', new Array());
		}
		
		// NOTIFICATION RELATED FUNCTIONS
		public function notifications_get():void {
			invokeMethod('facebook.notifications.get', new Array());
		}	
		
		public function notifications_sendSingle(pToUID:String, pMessage:String, pSendEmail:Boolean):void {
			notifications_send([pToUID], pMessage, pSendEmail);
		}
		
		public function notifications_send(pToUIDs:Array, pMessage:String, pSendEmail:Boolean):void {
			var params:Array = new Array();
			params['to_ids'] = pToUIDs;
			params['markup'] = pMessage;
			params['no_email'] = pSendEmail;
			invokeMethod('facebook.notifications.send', params);
		}
		
		// PROFILE RELATED FUNCTIONS
		public function profile_setFBML(pMarkup:String, pUID:String=''):void {
			var params:Array = new Array();
			params['markup'] = pMarkup;
			params['uid'] = pUID;
			invokeMethod('facebook.profile.setFBML', params);
		}
		
		public function profile_getFBML(pUID:String=''):void {
			var params:Array = new Array();
			params['uid'] = pUID;
			invokeMethod('facebook.profile.getFBML', params);
		}
		
		// USER RELATED FUNCTIONS
		public function users_getInfo(pUIDs:Array, pFields:Array):void {
			var params:Array = new Array();
			params['uids'] = pUIDs;
			params['fields'] = pFields;
			invokeMethod('facebook.users.getInfo', params);
		}
		
		public function users_getLoggedInUser():void {
			invokeMethod('facebook.users.getLoggedInUser', new Array());
		}
		
		// EVENT RELATED FUNCTIONS
		public function events_get(pUID:String, pEIDS:Array, pStartTime:Number=0, pEndTime:Number=0, pRSVPStatus:String=''):void {
			var params:Array = new Array();
			params['uid'] = pUID;
			params['eids'] = pEIDS;
			params['start_time'] = pStartTime;
			params['end_time'] = pEndTime;
			params['rsvp_status'] = pRSVPStatus;
			invokeMethod('facebook.events.get',params);
		}
		
		public function events_getMembers(pEventId:String):void {
			var params:Array = new Array();
			params['eid'] = pEventId;
			invokeMethod('facebook.events.getMembers',params);
		}
		
		// GROUP RELATED FUNCTIONS
		public function groups_get(pUID:String, pGIDs:Array):void {
			var params:Array = new Array();
			params['uid'] = pUID;
			params['gids'] = pGIDs;
			invokeMethod('facebook.groups.get',params);
		}
		
		public function groups_getMembers(pGroupId:String):void {
			var params:Array = new Array();
			params['gid'] = pGroupId;
			invokeMethod('facebook.groups.getMembers',params);
		}
		
		// PHOTO RELATED FUNCTIONS				
		public function photos_get(pSubjectIdFilter:String='', pAlbumIdFilter:String='', pPhotoIdsFilter:Array=null):void {
			var params:Array = new Array();
			params['subj_id'] = pSubjectIdFilter;
			params['aid'] = pAlbumIdFilter;
			params['pPhotoIdsFilter'] = pPhotoIdsFilter;
			invokeMethod('facebook.photos.get',params);
		}
		
		public function photos_getAlbums(pUID:String, pAlbumIds:Array=null):void {
			var params:Array = new Array();
			params['uid'] = pUID;
			params['aids'] = pAlbumIds;
			invokeMethod('facebook.photos.getAlbums', params);
			
		}
		public function photos_getTags(pPIDs:Array):void {
			var params:Array = new Array();
			params['pids'] = pPIDs;
			invokeMethod('facebook.photos.getTags', params);			
		}
		
		/**
		 * The method that is used to actually invoke a Facebook method using 
		 * Facebook's REST interface.  All other methods are simple wrappers to
		 * this method.
		 * 
		 * @param pMethodName the name of the method that should be invoked.
		 * @param pParams list of params to be passed as paramters to the named method
		 */
		public function invokeMethod(pMethodName:String, pParams:Array=null):void {
			pParams['method'] = pMethodName;
			pParams['session_key'] = mSessionKey;
			pParams['api_key'] = mAPIKey;
			pParams['call_id'] = new Date().time;
			pParams['v'] = '1.0';
			
			var postParams:URLVariables = new URLVariables();
			for (var key:String in pParams) {
				var value:String = pParams[key];
				if (getQualifiedClassName(value) == "Array") {
					var arr:Array = value as Array;
					value = arr.join(",");
				}
				postParams[key] = value;
			}
			
			// generate our sig
			postParams.sig = generateSignature(pParams);
			
			var request:URLRequest = new URLRequest(REST_SERVER_URL);
			request.data = postParams;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, onRequestComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onRequestError);         
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onRequestError); 
			
			loader.load(request);
		}
		
		namespace fb = "http://api.facebook.com/1.0/";		
		internal function onRequestComplete(pEvent:Event):void {
			mResponse = new XML(pEvent.target.data);
			var resultEvent:FacebookRequestEvent;
			
			if (mResponse.fb::error_msg.length() > 0) {
				resultEvent = new FacebookRequestEvent(mResponse, false, mResponse.fb::error_msg);	
			}
			else {
				resultEvent = new FacebookRequestEvent(mResponse, true, null);
			}
			
			dispatchEvent(resultEvent);
			
		}
		
		internal function onRequestError(pEvent:TextEvent):void {
			var resultEvent:FacebookRequestEvent = new FacebookRequestEvent(mResponse, false, pEvent.text);
			dispatchEvent(resultEvent);
		}
		
		internal function generateSignature(pParams:Array):String {
			var params:Array = new Array();
			for (var key:String in pParams) {
				var value:String = pParams[key];
				if (key !== 'sig') {
					params.push(key + '=' + value);
				}
			}
			
			params.sort();
			var valueToHash:String = params.join('');
			valueToHash += mSecret;
			return MD5.encrypt(valueToHash);
		}
	}
}
