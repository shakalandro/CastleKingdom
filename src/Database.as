package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;

	public class Database
	{
		
		/**
		 * This is the main getter method that is called by all the public getter methods. This makes the
		 * general passing of params to php for the sql query. It also makes an event listner that will
		 * call the appropriate event method for the getter.
		 *  
		 * @param uid the uid to get the information for.
		 * @param callback a function that takes one parameter, an object, that holds the information
		 *        returned from the sql query.
		 * @param url the url to connect to to pass variables to php.
		 * @param eventFunction the event function to call that corresponds to the private helper function
		 *        for the public getters.
		 * 
		 */		
		private static function getMain(url:String, callback:Function, ids:Object = null):void
		{
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			if (ids != null) {
				var variables:URLVariables = new URLVariables();
				variables.id = ids.toString() + "";
				request.data = variables;
			}
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {
				callback(new XML(evt.target.data));
			});
			loader.load(request);
		}
		
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
//		public static function getUserInfo(uid:int, callback:Function):void
//		{
//			getMain(uid, callback, "http://24.18.189.178/CastleKingdom/database/getUserInfo.php", getUserInfoHelper);
//		}
		
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
//		public static function getUserCastle(uid:int, callback:Function):void
//		{
//			getMain(uid, callback, "http://24.18.189.178/CastleKingdom/database/getUserCastle.php", getUserCastleHelper);
//		}
		
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
//		private static function getUserCastleHelper(evt:Event, callback:Function):void
//		{
//			var xmlData:XML = new XML(evt.target.data);
//			getMainHelper(xmlData, xmlData.cpart, "cpart", callback);
//		}
		
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
//		public static function getUserDef(uid:int, callback:Function):void
//		{
//			getMain(uid, callback, "http://24.18.189.178/CastleKingdom/database/getUserDef.php", getUserDefHelper);
//		}
		
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
//		private static function getUserDefHelper(evt:Event, callback:Function):void
//		{
//			var xmlData:XML = new XML(evt.target.data);
//			getMainHelper(xmlData, xmlData.def, "def", callback);
//		}
		
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
//		public static function getUserLease(uid:int, callback:Function):void
//		{
//			getMain(uid, callback, "http://24.18.189.178/CastleKingdom/database/getUserLeases.php", getUserLeaseHelper);
//		}
		
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
//		private static function getUserLeaseHelper(evt:Event, callback:Function):void
//		{
//			var xmlData:XML = new XML(evt.target.data);
//			getMainHelper(xmlData, xmlData.lease, "lease", callback);
//		}
		
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
//		public static function getUserAttacks(uid:int, callback:Function):void
//		{
//			getMain(uid, callback, "http://24.18.189.178/CastleKingdom/database/getUserAttacks.php", getUserAttackHelper);
//		}
		
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
		
		
		/**
		 * The main private helper function that all the other private getter helper functions
		 * call. This one process all the data and create the object that will be passed to the
		 * callback function.
		 *  
		 * @param xmlData the xml data that is retrieved from the php request.
		 * @param xmlList the list that corresponds to the xml (i.e. xmlData.attack)
		 * @param type the type of the getter (i.e. def, attack, lease)
		 * @param callback the callback function that takes a single parameter, an object, that
		 *        has the information from the sql query.
		 * 
		 */		
		public static function getUserInfo(callback:Function, ids:Object = null):void {
			getMain("games.washington.edu/capstone/11sp/castlekd/database/getUserInfo.php", function(xmlData:XML):void {
				callback(processList(xmlData.def, function(unit:XML):Object {
					return {
						uid: unit.uid,
						gold: unit.gold,
						units: unit.units
					};
				}));
			}, ids);
		}
		
		public static function getDefenseUnitInfo(callback:Function, ids:Object = null):void {
			getMain("games.washington.edu/capstone/11sp/castlekd/database/getDefInfo.php", function(xmlData:XML):void {
				callback(processList(xmlData.def, function(unit:XML):Object {
					return {
						did: unit.did,
						name: unit.name,
						level: unit.level,
						unitCost: unit.unitCost,
						maxHealth: unit.maxHealth,
						range: unit.range,
						damage: unit.damage,
						rate: unit.rate,
						type: unit.type,
						clas: unit.clas
					};
				}));
			}, ids);
		}

		public static function getEnemyInfo(callback:Function, ids:Object = null):void {
			getMain("games.washington.edu/capstone/11sp/castlekd/database/getArmyInfo.php", function(xmlData:XML):void {
				callback(processList(xmlData.army, function(unit:XML):Object {
					return {
						aid: unit.aid,
						name: unit.name,
						level: unit.level,
						unitCost: unit.unitCost,
						goldCost: unit.goldCost,
						maxHealth: unit.maxHealth,
						range: unit.range,
						damage: unit.damage,
						rate: unit.rate,
						reward: unit.reward,
						move: unit.move,
						type: unit.type,
						clas: unit.clas
					};
				}));
			}, ids);
		}
		
		private static function processList(units:XMLList, format:Function):Array {
			if (units != null && units.length != 0) {
				var result:Array = [];
				for each(var xml:XML in units) {
					result.push(format(xml));
				}
				return result;
			} else {
				return null;
			}
		}
	}
}