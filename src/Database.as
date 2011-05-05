package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;
	
	public class Database
	{
		
		private static var _userInfo:Array;
		private static var _userUps:Array;
		private static var _enemyInfo:Array;
		private static var _defUnitInfo:Array;
		private static var _mineInfo:Array;
		private static var _foundryInfo:Array;
		private static var _aviaryInfo:Array;
		private static var _barracksInfo:Array;
		private static var _castleInfo:Array;
		private static var _userLeaseInfo:Array;
		private static const _startGold:int = 0;
		private static const _startUnits:int = 5;
		
		
		private static function getMain(url:String, callback:Function, ids:Object = null):void
		{
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			if (ids != null) {
				var variables:URLVariables = new URLVariables();
				variables.uid = ids.toString() + "";
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
		 * Passes an array of objects representing the given users (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, gold, units}
		 * </p>
		 * <p>
		 * If the user does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */		
		public static function getUserInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.def, function(unit:XML):Object {
						return {
							id: unit.uid,
							gold: unit.gold,
							units: unit.units
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects where an object represents the given users,
		 * (by the ids), castle upgrades. The objects in the array that are passed to the callback 
		 * function is of the form: 
		 * </p>
		 * <p>
		 * {id, cid, bid, fid, mid, aid, xpos, ypos}
		 * </p>
		 * <p>
		 * There will only be one of cid, bid, fid, mid, or aid filled in since an upgrade is only
		 * one of them. This means that the other fields in the object will be the empty string.
		 * (This should be checked for if the objects are going to be used). 
		 * </p>
		 * 
		 * @param callback a function that takes an array of objects as a parameter
		 * @param ids either a integer or an array of integers
		 * @param forceRefresh
		 * 
		 */		
		public static function getUserUpgrades(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userUps == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserUpgrades.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							cid: unit.cid,
							bid: unit.bid,
							fid: unit.fid,
							mid: unit.mid,
							aid: unit.aid,
							xpos: unit.xpos,
							ypos: unit.ypos
						};
					})
					callback(_userUps);
				}, ids);
			} else {
				callback(getAll(_userUps, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given defence (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, level, unitCost, maxHealth, range, damage, rate, type, clas}
		 * </p>
		 * <p>
		 * If the defence does not have any defence information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getDefenseUnitInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _defUnitInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getDefInfo.php", function(xmlData:XML):void {
					_defUnitInfo = processList(xmlData.def, function(unit:XML):Object {
						return {
							id: unit.did,
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
					});
					callback(_defUnitInfo);
				}, ids);
			} else {
				callback(getAll(_defUnitInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given enemies (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, level, unitCost, goldCost, maxHealth, range, damage, rate, reward, move, type, clas}
		 * </p>
		 * <p>
		 * If the enemy does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getEnemyInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _enemyInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getArmyInfo.php", function(xmlData:XML):void {
					_enemyInfo = processList(xmlData.army, function(unit:XML):Object {
						return {
							id: unit.aid,
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
					});
					callback(_enemyInfo);
				}, ids);
			} else {
				callback(getAll(_enemyInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given mine (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, unitWorth, goldCost}
		 * </p>
		 * <p>
		 * If the mine does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getMineInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _mineInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getMineInfo.php", function(xmlData:XML):void {
					_mineInfo = processList(xmlData.mine, function(unit:XML):Object {
						return {
							id: unit.mid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_mineInfo);
				}, ids);
			} else {
				callback(getAll(_mineInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given foundry (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, unitWorth, goldCost}
		 * </p>
		 * <p>
		 * If the foundry does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getFoundryInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _foundryInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getFoundryInfo.php", function(xmlData:XML):void {
					_foundryInfo = processList(xmlData.foundry, function(unit:XML):Object {
						return {
							id: unit.fid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_foundryInfo);
				}, ids);
			} else {
				callback(getAll(_foundryInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given aviary (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, unitWorth, goldCost}
		 * </p>
		 * <p>
		 * If the aviary does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getAviaryInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _aviaryInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getAviaryInfo.php", function(xmlData:XML):void {
					_aviaryInfo = processList(xmlData.aviary, function(unit:XML):Object {
						return {
							id: unit.aid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_aviaryInfo);
				}, ids);
			} else {
				callback(getAll(_aviaryInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given barrack (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, unitWorth, goldCost}
		 * </p>
		 * <p>
		 * If the barrack does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getBarracksInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _barracksInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getBarracksInfo.php", function(xmlData:XML):void {
					_barracksInfo = processList(xmlData.barrack, function(unit:XML):Object {
						return {
							id: unit.bid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_barracksInfo);
				}, ids);
			} else {
				callback(getAll(_barracksInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given castles (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, unitWorth, goldCost}
		 * </p>
		 * <p>
		 * If the castle does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getCastleInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _castleInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getCastleInfo.php", function(xmlData:XML):void {
					_castleInfo = processList(xmlData.castle, function(unit:XML):Object {
						return {
							id: unit.cid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_castleInfo);
				}, ids);
			} else {
				callback(getAll(_castleInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given users (based on the given ids) lease information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, lid, numUnits}
		 * </p>
		 * <p>
		 * If the user does not have any lease information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getUserLeaseInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userLeaseInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserLeases.php", function(xmlData:XML):void {
					_userLeaseInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							lid: unit.lid,
							numUnits: unit.numUnits
						};
					})
					callback(_userLeaseInfo);
				}, ids);
			} else {
				callback(getAll(_userLeaseInfo, ids));
			}
		}
		
		private static function getAll(stuff:Array, ids:Object):Array {
			if (stuff == null) {
				return null;
			}
			if (ids == null) {
				return stuff;
			} else if (ids is Number) {
				ids = [(ids as Number)];
			}
			ids = (ids as Array);
			stuff = stuff.filter(function(item:Object, index:int, arr:Array):Boolean {
				return ids.indexOf(item.id) >= 0;
			});
			if (stuff.length != ids.length) {
				return null;
			} else {
				return stuff;
			}
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
		
		private static function update(url:String, variables:URLVariables):void
		{
			var request:URLRequest = new URLRequest(url);
			
			request.data = variables;
			request.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		/**
		 * <p>
		 * Adds a new user with the given uid to the database with the basic gold and 
		 * units stats. Thus, a new entry of the following form will be entered into the db:
		 * </p>
		 * <p>
		 * (uid, 0, 5)
		 * </p>
		 *  
		 * @param uid a users facebook id
		 * 
		 */		
		public static function addNewUser(uid:int):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + uid;
			variables.gold = "" + _startGold;
			variables.units = "" + _startUnits;
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/addNewUser.php", variables);
		}
		
		/**
		 * <p>
		 * Updates the given users information to what is provided in the given object. The object must be of the
		 * form: 
		 * </p>
		 * <p>
		 * {id, gold, units}
		 * </p>
		 *  
		 * @param userInfo an object of the specified form and should not be null
		 * 
		 */		
		public static function updateUserInfo(userInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + userInfo["id"];
			variables.gold = "" + userInfo["gold"];
			variables.units = "" + userInfo["units"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/updateUserInfo.php", variables);
		}
		
		/**
		 * <p>
		 * Adds a new lease for the given user. Updates the user's information so that the number of units they
		 * are leasing out is decremented from their total number of units and the person they are leasing to 
		 * has their units increased. This is done based on the object passed in. The object should be of the 
		 * following form:
		 * </p>
		 * <p>
		 * {id, lid, numUnits}
		 * </p>
		 * <p>
		 * id is the uid of the person doing the leasing, lid is the uid of the person who is getting the leased
		 * units and numUnits is the number of units being leased. 
		 * </p>
		 *  
		 * @param leaseInfo must be of the specified format and != null
		 * 
		 */		
		public static function addUserLease(leaseInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + leaseInfo["id"];
			variables.lid = "" + leaseInfo["lid"];
			variables.numUnits = "" + leaseInfo["numUnits"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/addUserLease.php", variables);
		}
		
		/**
		 * <p>
		 * Removes the lease information for the given user from the object who has a lease contract 
		 * with the user who has lid in the given object. Increments the units for the user with uid = id
		 * and decrements the units for the user with uid = lid by numUnits. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {id, lid, numUnits}
		 * </p>
		 * 
		 * @param leaseInfo must be of the specified format and != null
		 * 
		 */		
		public static function removeUserLease(leaseInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + leaseInfo["id"];
			variables.lid = "" + leaseInfo["lid"];
			variables.numUnits = "" + leaseInfo["numUnits"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/removeUserLease.php", variables);
		}
	}
}
