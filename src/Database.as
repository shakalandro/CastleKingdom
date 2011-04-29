package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;

	public class Database
	{
		
		/**
		 * <p>
		 * Passes an object that stores the information for a user with the given uid to the
		 * call back function. The user information came from the database and the object is
		 * of the following form:
		 * </p>
		 * <p>
		 * 		userInfo = {uid:userId, gold:userGold, units:userUnits}
		 * </p>
		 * <p>
		 * If the uid does not match any user in the database, then the object passed to the
		 * callback function is null.
		 * </p>
		 * 
		 * @param uid must be a valid uid for some user in the database
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the userInfo.
		 * 
		 */		
		public static function getUserInfo(uid:int, callback:Function):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = uid + "";
			
			var request:URLRequest = new URLRequest("http://24.18.189.178/CastleKingdom/database/getUserInfo.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {getUserInfoHelper(evt, callback);});
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Receives information from php that represents the results of the sql query for
		 * a given users information. The information received from php is in XML format
		 * like the following:
		 * </p>
		 * <pre>
		 * &lt;user&gt;
		 * 	&lt;uid&gt;userId&lt;/uid&gt;
		 * 	&lt;gold&gt;userGold&lt;/gold&gt;
		 * 	&lt;units&gt;userUnits&lt;/units&gt;
		 * &lt;/user&gt;
		 * </pre>
		 * <p>
		 * After reading the php in, the user object is created and passed to the callback function.
		 * </p>
		 * 
		 * @param evt the event that the php has completed rendering on the screen
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user info.
		 * 
		 */		
		private static function getUserInfoHelper(evt:Event, callback:Function):void
		{
			var xmlData:XML = new XML(evt.target.data);
			var users:XMLList = xmlData.user;
			var user:XML = users[0];
			if (user != null) {
				var userInfo:Object = {uid:user.uid.text(), gold:user.gold.text(), units:user.units.text()};
				callback(userInfo);
			} else {
				callback(null);
			}
		}
		
		/**
		 * <p>
		 * Passes an object that stores the information for a user's castle with the given uid to the
		 * call back function. The user's castle information came from the database and the object is
		 * of the following form:
		 * </p>
		 * <p>
		 * 		userCastle = {uid:userId, cpart0:{cid:cId, xpos:xPos, ypos:yPos}, ..., cpartN:{cid:cId, xpos:xPos, ypos:yPos}}
		 * </p>
		 * <p>
		 * If the uid does not match any user in the database, then the object passed to the
		 * callback function is null.
		 * </p>
		 * 
		 * @param uid must be a valid uid for some user in the database
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the userCastle.
		 * 
		 */
		public static function getUserCastle(uid:int, callback:Function):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = uid + "";
			
			var request:URLRequest = new URLRequest("http://24.18.189.178/CastleKingdom/database/getUserCastle.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {getUserCastleHelper(evt, callback);});
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Receives information from php that represents the results of the sql query for
		 * a given user's castle. The information received from php is in XML format
		 * like the following:
		 * </p>
		 * <pre>
		 * &lt;user&gt;
		 * 	&lt;uid&gt;userId&lt;/uid&gt;
		 * 	&lt;cpart0&gt;
		 * 		&lt;cid&gt;cId&lt;/cid&gt;
		 * 		&lt;xpos&gt;xPos&lt;/xpos&gt;
		 * 		&lt;ypos&gt;yPos&lt;/ypos&gt;
		 * 	&lt;/cpart0&gt;
		 * 	...
		 * &lt;/user&gt;
		 * </pre>
		 * <p>
		 * After reading the php in, the user object is created and passed to the callback function.
		 * </p>
		 * 
		 * @param evt the event that the php has completed rendering on the screen
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's castle.
		 * 
		 */
		private static function getUserCastleHelper(evt:Event, callback:Function):void
		{
			var xmlData:XML = new XML(evt.target.data);
			var user:XMLList = xmlData.user;
			var castleParts:XMLList = xmlData.cpart;
			if (user != null) {
				var userCastle:Object = {};
				userCastle["uid"] = xmlData.uid;
				var i:int = 0;
				for each(var cPart:XML in castleParts) {
					userCastle["cpart" + i] = {cid:cPart.cid, xpos:cPart.xpos, ypos:cPart.ypos};
					i++;
				}
				userCastle["size"] = i;
				callback(userCastle);
			} else {
				callback(null);
			}
		}
		
		/**
		 * <p>
		 * Passes an object that stores the information for a user's defense with the given uid to the
		 * call back function. The user's defence information came from the database and the object is
		 * of the following form:
		 * </p>
		 * <p>
		 * 		userDef = {uid:userId, def0:{did:cId, xpos:xPos, ypos:yPos}, ..., defN:{did:cId, xpos:xPos, ypos:yPos}}
		 * </p>
		 * <p>
		 * If the uid does not match any user in the database, then the object passed to the
		 * callback function is null.
		 * </p>
		 * 
		 * @param uid must be a valid uid for some user in the database
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's defence.
		 * 
		 */
		public static function getUserDef(uid:int, callback:Function):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = uid + "";
			
			var request:URLRequest = new URLRequest("http://24.18.189.178/CastleKingdom/database/getUserDef.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {getUserDefHelper(evt, callback);});
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Receives information from php that represents the results of the sql query for
		 * a given user's defence. The information received from php is in XML format
		 * like the following:
		 * </p>
		 * <pre>
		 * &lt;user&gt;
		 * 	&lt;uid&gt;userId&lt;/uid&gt;
		 * 	&lt;def0&gt;
		 * 		&lt;cid&gt;cId&lt;/cid&gt;
		 * 		&lt;xpos&gt;xPos&lt;/xpos&gt;
		 * 		&lt;ypos&gt;yPos&lt;/ypos&gt;
		 * 	&lt;/def0&gt;
		 * 	...
		 * &lt;/user&gt;
		 * </pre>
		 * <p>
		 * After reading the php in, the user object is created and passed to the callback function.
		 * </p>
		 * 
		 * @param evt the event that the php has completed rendering on the screen
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's defence.
		 * 
		 */
		private static function getUserDefHelper(evt:Event, callback:Function):void
		{
			var xmlData:XML = new XML(evt.target.data);
			var user:XMLList = xmlData.user;
			var defParts:XMLList = xmlData.def;
			if (user != null && defParts.length != 0) {
				var userDef:Object = {};
				userDef["uid"] = xmlData.uid;
				var i:int = 0;
				for each(var dPart:XML in defParts) {
					userDef["def" + i] = {did:dPart.did, xpos:dPart.xpos, ypos:dPart.ypos};
					i++;
				}
				userDef["size"] = i;
				callback(userDef);
			} else {
				callback(null);
			}
		}
		
		/**
		 * <p>
		 * Passes an object that stores the information for a user's leases with the given uid to the
		 * call back function. The user's lease information came from the database and the object is
		 * of the following form:
		 * </p>
		 * <p>
		 * 		userLease = {uid:userId, lease0:{lid:leaseUId, numUnits:num}, ..., leaseN:{lid:leaseUId, numUnits:num}}
		 * </p>
		 * <p>
		 * The lid refers to the person that uid is leasing their units to and numUnits in the number of
		 * units they are leasing.
		 * If the uid does not match any user in the database, then the object passed to the
		 * callback function is null.
		 * </p>
		 * 
		 * @param uid must be a valid uid for some user in the database
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's leases.
		 * 
		 */
		public static function getUserLease(uid:int, callback:Function):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = uid + "";
			
			var request:URLRequest = new URLRequest("http://24.18.189.178/CastleKingdom/database/getUserLeases.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {getUserLeaseHelper(evt, callback);});
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Receives information from php that represents the results of the sql query for
		 * a given user's leases. The information received from php is in XML format
		 * like the following:
		 * </p>
		 * <pre>
		 * &lt;user&gt;
		 * 	&lt;lease&gt;
		 * 		&lt;uid&gt;userId&lt;/uid&gt;
		 * 		&lt;lid&gt;leaseId&lt;/lid&gt;
		 * 		&lt;numUnits&gt;numUnits&lt;/numUnits&gt;
		 * 	&lt;lease&gt;
		 * 	...
		 * &lt;/user&gt;
		 * </pre>
		 * <p>
		 * After reading the php in, the user object is created and passed to the callback function.
		 * </p>
		 * 
		 * @param evt the event that the php has completed rendering on the screen
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's leases.
		 * 
		 */
		private static function getUserLeaseHelper(evt:Event, callback:Function):void
		{
			var xmlData:XML = new XML(evt.target.data);
			var user:XMLList = xmlData.user;
			var leases:XMLList = xmlData.lease;
			if (user != null && leases.length != 0) {
				var userLeases:Object = {};
				userLeases["uid"] = xmlData.uid;
				var i:int = 0;
				for each(var lease:XML in leases) {
					userLeases["lease" + i] = {lid:lease.lid, numUnits:lease.numUnits};
					i++;
				}
				userLeases["size"] = i;
				callback(userLeases);
			} else {
				callback(null);
			}
		}
		
		/**
		 * <p>
		 * Passes an object that stores the information for a user's attacks with the given uid to the
		 * call back function. The user's attack information came from the database and the object is
		 * of the following form:
		 * </p>
		 * <p>
		 * 		userLease = {uid:userId, attack0:aid, ..., attackN:aid}
		 * </p>
		 * <p>
		 * The aid refers to the person that uid is attacking.
		 * If the uid does not match any user in the database, then the object passed to the
		 * callback function is null.
		 * </p>
		 * 
		 * @param uid must be a valid uid for some user in the database
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's attacks.
		 * 
		 */
		public static function getUserAttacks(uid:int, callback:Function):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = uid + "";
			
			var request:URLRequest = new URLRequest("http://24.18.189.178/CastleKingdom/database/getUserAttacks.php");
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {getUserAttackHelper(evt, callback);});
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Receives information from php that represents the results of the sql query for
		 * a given user's attacks. The information received from php is in XML format
		 * like the following:
		 * </p>
		 * <pre>
		 * &lt;user&gt;
		 * 	&lt;attck&gt;
		 * 		&lt;aid&gt;aId&lt;/aid&gt;
		 * 	&lt;attack&gt;
		 * 	...
		 * &lt;/user&gt;
		 * </pre>
		 * <p>
		 * After reading the php in, the user object is created and passed to the callback function.
		 * </p>
		 * 
		 * @param evt the event that the php has completed rendering on the screen
		 * @param callback a callback function that takes a single parameter, an Object, that
		 *                 represents the user's attacks.
		 * 
		 */
		private static function getUserAttackHelper(evt:Event, callback:Function):void
		{
			var xmlData:XML = new XML(evt.target.data);
			var user:XMLList = xmlData.user;
			var attacks:XMLList = xmlData.attack;
			if (user != null && attacks.length != 0) {
				var userAttacks:Object = {};
				userAttacks["uid"] = xmlData.uid;
				var i:int = 0;
				for each(var attack:XML in attacks) {
					userAttacks["attack" + i] = attack.aid;
					i++;
				}
				userAttacks["size"] = i;
				callback(userAttacks);
			} else {
				callback(null);
			}
		}
	}
}