package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;
	
	public class Database
	{
		
		public static const START_GOLD:int = Castle.START_GOLD;
		public static const START_UNITS:int = Castle.START_TOWER_CAPACITY;
		private static var _save:FlxSave;
		private static var _loaded:Boolean;
		private static var _userInfo:Array;
		private static var _userUps:Array;
		private static var _enemyInfo:Array;
		private static var _defUnitInfo:Array;
		private static var _mineInfo:Array;
		private static var _foundryInfo:Array;
		private static var _aviaryInfo:Array;
		private static var _barracksInfo:Array;
		private static var _upgradeInfo:Array;
		private static var _castleInfo:Array;
		private static var _userLeaseInfo:Array;
		private static var _userTutorialInfo:Array;
		private static var _attacked:Array;
		private static var _pendingAttacks:Array;
		private static var _pendingUserLeaseInfo:Array;
		private static var _pendingLeases:Array;
		private static var _finishedAttacks:Array;
		private static var _userDef:Array;
		
		
		private static function getMain(url:String, callback:Function, ids:Object = null):void
		{
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			if (ids != null) {
				var variables:URLVariables = new URLVariables();
				variables.uid = ids.toString() + "";
				request.data = variables;
				Util.log("request.data.toString: " + request.data.toString());
			}
			var loader:URLLoader = new URLLoader();
			Util.log("request.url: " + request.url);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			(FlxG.state as GameState).loading = true;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {
				(FlxG.state as GameState).loading = false;
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
			Util.logObj("\n\nuid to addnewuser: ", ids);
			if (forceRefresh || _userInfo == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserInfo.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_userInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							gold: unit.gold,
							units: unit.units
						};
					});
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given users (based on the given ids) defence information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {did, xpos, ypos}
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
		public static function getUserDef(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userDef == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserDef.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_userDef = processList(xmlData.def, function(unit:XML):Object {
						return {
							did: unit.did,
							xpos: unit.xpos,
							ypos: unit.ypos
						};
					});
					callback(_userDef);
				}, ids);
			} else {
				callback(getAll(_userDef, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects where an object represents the given users,
		 * (by the ids), castle upgrades. The objects in the array that are passed to the callback 
		 * function is of the form: 
		 * </p>
		 * <p>
		 * {id, upid, xpos, ypos}
		 * </p>
		 * <p>
		 * The id is the id of the user, the upid is the id of the upgrade, and the xpos is the 
		 * x-position and ypos is the y-positions. 
		 * </p>
		 * 
		 * @param callback a function that takes an array of objects as a parameter
		 * @param ids either a integer or an array of integers
		 * @param forceRefresh
		 * 
		 */		
		public static function getUserUpgrades(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userUps == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserUpgrades.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_userUps = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							upid: unit.upid,
							xpos: unit.xpos,
							ypos: unit.ypos
						};
					});
					callback(_userUps);			
				}, ids);
			} else {
				callback(getAll(_userUps, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given users (based on the given ids) pending lease information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, lid, numUnits}
		 * </p>
		 * <p>
		 * id = the user uid, lid = the uid of the person you are leasing to, and numUnits is the number of units
		 * they are leasing to lid.
		 * If the user does not have any lease information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getPendingUserLeases(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void
		{
			if (forceRefresh || _pendingUserLeaseInfo == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getPendingUserLeases.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_pendingUserLeaseInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							lid: unit.lid,
							numUnits: unit.numUnits
						};
					});
					callback(_pendingUserLeaseInfo);
				}, ids);
			} else {
				callback(getAll(_pendingUserLeaseInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given users (based on the given ids) lease information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, lid, numUnits, pending, accepted}
		 * </p>
		 * <p>
		 * id = the user uid, lid = the uid of the person you are leasing to, and numUnits is the number of units
		 * they are leasing to lid.
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
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserLeases.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_userLeaseInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							lid: unit.lid,
							numUnits: unit.numUnits,
							pending: unit.pending,
							accepted: unit.accepted
						};
					});
					callback(_userLeaseInfo);
				}, ids);
			} else {
				callback(getAll(_userLeaseInfo, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing the given users (based on the given ids) tutorial information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, tut1, tut2, tut3, tut4, tut5}
		 * </p>
		 * <p>
		 * the fields tut1,...,tut5 are either 0 or 1 (0 indicates false, 1 indicates true).
		 * If the user does not have any tutorial information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getUserTutorialInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userTutorialInfo == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserTutorial.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_userTutorialInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							tut1: unit.tut1,
							tut2: unit.tut2,
							tut3: unit.tut3,
							tut4: unit.tut4,
							tut5: unit.tut5,
							tut6: unit.tut6
						};
					});
					callback(_userTutorialInfo);
				}, ids);
			} else {
				callback(getAll(_userTutorialInfo , ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing which ids (given to the function) are being attacked to
		 * the callback function. The object that is passed to the callback function in the array is of the following form:
		 * </p>
		 * <p>
		 * {id}
		 * </p>
		 * <p>
		 * If the user does not have any tutorial information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */		
		public static function isBeingAttacked(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _attacked == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserAttacks.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_attacked = processList(xmlData.attack, function(unit:XML):Object {
						return {
							id: unit.aid
						};
					});
					callback(_attacked);
				}, ids);
			} else {
				callback(getAll(_attacked , ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing which ids (given to the function) have pending leases from whom
		 * the callback function. The object that is passed to the callback function in the array is of the following form:
		 * </p>
		 * <p>
		 * {id}
		 * </p>
		 * <p>
		 * The id is the id of the person who has the lease (one of the ids given to the function)
		 * If the user does not have any pending information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function hasPendingLeases(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _pendingLeases == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/pendingUserLeases.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_pendingLeases = processList(xmlData.lease, function(unit:XML):Object {
						return {
							id: unit.lid
						};
					});
					callback(_pendingLeases);
				}, ids);
			} else {
				callback(getAllPendingLeases(_pendingLeases , ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing which ids (given to the function) are being attacked to by whom
		 * the callback function. The object that is passed to the callback function in the array is of the following form:
		 * </p>
		 * <p>
		 * {id, aid, leftSide, rightSide}
		 * </p>
		 * <p>
		 * The id is the id of the person who is attacking the aid (one of the ids given to the function)
		 * If the user does not have any pending information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function pendingAttacks(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _pendingAttacks == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/pendingUserAttacks.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_pendingAttacks = processList(xmlData.attack, function(unit:XML):Object {
						return {
							id: unit.uid,
							aid: unit.aid,
							leftSide: unit.leftSide,
							rightSide: unit.rightSide
						};
					});
					callback(_pendingAttacks);
				}, ids);
			} else {
				callback(getAllPendingAttacks(_pendingAttacks, ids));
			}
		}
		
		/**
		 * <p>
		 * Passes an array of objects representing which attacks are finished for the given ids.
		 * The object that is passed to the callback function in the array is of the following form:
		 * </p>
		 * <p>
		 * {id, aid, winAmt}
		 * </p>
		 * <p>
		 * The id is the id of the person who is attacking the aid (one of the ids given to the function)
		 * If the user does not have any finished information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getFinishedAttacks(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _finishedAttacks == null) {
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getFinishedAttacks.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_finishedAttacks = processList(xmlData.attack, function(unit:XML):Object {
						return {
							id: unit.uid,
							aid: unit.aid,
							winAmt: unit.win
						};
					});
					callback(_finishedAttacks);
				}, ids);
			} else {
				callback(getAllPendingAttacks(_finishedAttacks, ids));
			}
		}
		
		private static function getAllPendingAttacks(stuff:Array, ids:Object):Array {
			if (stuff == null) {
				return null;
			}
			var idsArr:Array = null;
			if (ids == null) {
				return stuff;
			} else if (ids is Number) {
				idsArr = [ids] 
			} else if (ids is String) {
				idsArr = [parseInt(ids as String)];
			} else if (ids is Array) {
				idsArr = ids as Array;
			} else {
				return null;
			}
			var newStuff:Array = stuff.filter(function(item:Object, index:int, arr:Array):Boolean {
				return idsArr.indexOf(item.aid) >= 0;
			});
			if (newStuff.length != idsArr.length) {
				return null;
			} else {
				return newStuff;
			}
		}
		
		private static function getAllPendingLeases(stuff:Array, ids:Object):Array {
			if (stuff == null) {
				return null;
			}
			var idsArr:Array = null;
			if (ids == null) {
				return stuff;
			} else if (ids is Number) {
				idsArr = [ids] 
			} else if (ids is String) {
				idsArr = [parseInt(ids as String)];
			} else if (ids is Array) {
				idsArr = ids as Array;
			} else {
				return null;
			}
			var newStuff:Array = stuff.filter(function(item:Object, index:int, arr:Array):Boolean {
				return idsArr.indexOf(item.lid) >= 0;
			});
			if (newStuff.length != idsArr.length) {
				return null;
			} else {
				return newStuff;
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
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getDefInfo.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
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
				(FlxG.state as GameState).loading = true;
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getArmyInfo.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
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
		 * Passes an array of objects representing the given upgrade (based on the given ids) information to
		 * the callback function. The object that is passed to the callback function is of the following form:
		 * </p>
		 * <p>
		 * {id, name, level, unitWorth, goldCost, type}
		 * </p>
		 * <p>
		 * id = the upgrade id, name is the name of the upgrade piece, unitWorth is the worth of the upgrade
		 * piece, goldCost is the cost to "build" the new upgrade piece and type is what type the upgrade is.
		 * If the upgrade does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getUpgradesInfo(callback:Function, levels:Object = null, types:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _upgradeInfo == null) {
				(FlxG.state as GameState).loading = true;
				upgradeMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUpgradeInfo.php", function(xmlData:XML):void {
					(FlxG.state as GameState).loading = false;
					_upgradeInfo = processList(xmlData.upgrade, function(unit:XML):Object {
						return {
							id: unit.id,
							name: unit.name,
							level: unit.level,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost,
							type: unit.type
						};
					})
					callback(_upgradeInfo);
				}, levels, types);
			} else {
				callback(updateAll(_upgradeInfo, levels, types));
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
		 * id = the mine mid, name is the name of the mine piece, unitWorth is the worth of the mine
		 * piece, and goldCost is the cost to "build" the new mine piece.
		 * If the mine does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getMineInfo(callback:Function, levels:Object = null, forceRefresh:Boolean = false):void {
			getUpgradesInfo(callback, levels, "mine", forceRefresh);
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
		 * id = the foundry fid, name is the name of the foundry piece, unitWorth is the worth of the foundry
		 * piece, and goldCost is the cost to "build" the new foundry piece.
		 * If the foundry does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getFoundryInfo(callback:Function, levels:Object = null, forceRefresh:Boolean = false):void {
			getUpgradesInfo(callback, levels, "foundry", forceRefresh);
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
		 * id = the aviary aid, name is the name of the aviary piece, unitWorth is the worth of the aviary
		 * piece, and goldCost is the cost to "build" the new aviary piece.
		 * If the aviary does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getAviaryInfo(callback:Function, levels:Object = null, forceRefresh:Boolean = false):void {
			getUpgradesInfo(callback, levels, "aviary", forceRefresh);
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
		 * id = the barrack bid, name is the name of the barrack piece, unitWorth is the worth of the barrack
		 * piece, and goldCost is the cost to "build" the new barrack piece.
		 * If the barrack does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getBarracksInfo(callback:Function, levels:Object = null, forceRefresh:Boolean = false):void {
			getUpgradesInfo(callback, levels, "barracks", forceRefresh);
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
		 * id = the castle cid, name is the name of the castle piece, unitWorth is the worth of the castle
		 * piece, and goldCost is the cost to "build" the new castle piece.
		 * If the castle does not have any information, the the array that is passed to the callback is null.
		 * </p>
		 * 
		 * @param callback a function that takes one argument, an array of objects
		 * @param ids either a number or an array of numbers representing the user ids
		 * @param forceRefresh
		 * 
		 */
		public static function getCastleInfo(callback:Function, levels:Object = null, forceRefresh:Boolean = false):void {
			getUpgradesInfo(callback, levels, "castle", forceRefresh);
		}
		
		private static function updateAll(stuff:Array, levels:Object, types:Object):Array {
			if (stuff == null) {
				return null;
			}
			var levelsArr:Array = null;
			if (levels == null) {
				return stuff;
			} else if (levels is Number) {
				levelsArr = [levels] 
			} else if (levels is String) {
				levelsArr = [parseInt(levels as String)];
			} else if (levels is Array) {
				levelsArr = levels as Array;
			} else {
				return null;
			}
			
			var typesArr:Array = null;
			if (types == null) {
				return stuff;
			} else if (types is Number) {
				typesArr = [types] 
			} else if (types is String) {
				typesArr = [parseInt(types as String)];
			} else if (types is Array) {
				typesArr = types as Array;
			} else {
				return null;
			}
			var newStuff:Array = stuff.filter(function(item:Object, index:int, arr:Array):Boolean {
				return levelsArr.indexOf(item.level) < 0 && typesArr.indexOf(item.type) < 0;
			});;
			if (newStuff.length != stuff.length) {
				return null;
			} else {
				return stuff;
			}
		}
		
		private static function upgradeMain(url:String, callback:Function, levels:Object = null, types:Object = null):void
		{
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			var variables:URLVariables = new URLVariables();
			if (levels != null) {
				variables.levels = levels.toString() + "";
			}
			if (types != null) {
				variables.types = types.toString() + "";
			}
			request.data = variables;
			FlxG.log("request.data: " + request.data.toString());
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			(FlxG.state as GameState).loading = true;
			loader.addEventListener(Event.COMPLETE, function(evt:Event):void {
				(FlxG.state as GameState).loading = false;
				callback(new XML(evt.target.data));
			});
			loader.load(request);
		}
		
		private static function getAll(stuff:Array, ids:Object):Array {
			if (stuff == null) {
				return null;
			}
			var idsArr:Array = null;
			if (ids == null) {
				return stuff;
			} else if (ids is Number) {
				idsArr = [ids] 
			} else if (ids is String) {
				idsArr = [parseInt(ids as String)];
			} else if (ids is Array) {
				idsArr = ids as Array;
			} else {
				return null;
			}
			var newStuff:Array = stuff.filter(function(item:Object, index:int, arr:Array):Boolean {
				return idsArr.indexOf(item.id) < 0;
			});
			if (newStuff.length != idsArr.length) {
				return null;
			} else {
				return newStuff;
			}
		}
		
		private static function processList(units:XMLList, format:Function):Array {
			if (units != null && units.length() != 0) {
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
			Util.log("request.data.toString: " + request.data.toString());
			request.method = URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(request);
		}
		
		private static function updateCache(newInfo:Object, oldInfo:Array):void
		{
			if (oldInfo != null) {
				for (var i:int = 0; i < oldInfo.length; i++) {
					if (oldInfo[i].id == newInfo["id"]) {
						oldInfo[i] = newInfo;
						break;
					}
				}
			} else {
				oldInfo = [];
				oldInfo.push(newInfo);
			}
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
		public static function addNewUser(uid:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + uid;
			variables.gold = "" + START_GOLD;
			variables.units = "" + START_UNITS;
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/addNewUser.php", variables);
			_save.data.users[uid] = {info: {}, tut: {}, defs: [], leases: [], attacks: [], upgrades: []};
			_save.data.users[uid].info = {id: uid, gold: 0, units: 5};
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
			updateCache(userInfo, _userInfo);
			if (_save.data.users[userInfo.id] == undefined || _save.data.users[userInfo.id] == null) {
				_save.data.users[userInfo.id] = {info: {}, 
					tut: {id: userInfo.id, tut1: 0, tut2: 0, tut3: 0, tut4: 0, tut5: 0, tut6: 0}, 
					leases: [], attacks: [], upgrades: []};
			}
			_save.data.users[userInfo.id].info = userInfo;
		}
		
		/**
		 * <p>
		 * Removes the given users def information.
		 *  
		 * @param id must be a uid
		 * 
		 */
		public static function removeUserDef(id:String):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + id;
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/removeUserDef.php", variables);
			if (_userDef != null)
				_userDef = [];
			if (_save.data.users[id] == undefined || _save.data.users[id] == null) {
				_save.data.users[id] = {info: {}, 
					tut: {id: id, tut1: 0, tut2: 0, tut3: 0, tut4: 0, tut5: 0, tut6: 0}, 
					defs: [], leases: [], attacks: [], upgrades: []};
			}
		}
		
		/**
		 * <p>
		 * Updates the given users tutorial information by setting the tutorial level completion to
		 * true for the given level.
		 *  
		 * @param uid the given users uid
		 * @param tutLevelComp the tutorial level that has been completed
		 * 
		 */
		public static function updateUserTutorialInfo(uid:String, tutLevelComp:int):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + uid;
			variables.tutNum = "" + tutLevelComp;
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/updateUserTutorialInfo.php", variables);
			var userTut:Object = {id: uid, tut1: 0, tut2: 0, tut3: 0, tut4: 0, tut5: 0, tut6: 0};
			for (var i:int = 1; i < tutLevelComp; i++) {
				userTut["tut" + i] = 1; 
			}
			updateCache(userTut, _userTutorialInfo);
			if (_save.data.users[uid] == undefined || _save.data.users[uid] == null) {
				_save.data.users[uid] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			}
			_save.data.users[uid].tut = userTut;
		}
		
		/**
		 * <p>
		 * Should call getUserInfo first to determine how many units are allowed to be leased at one time.
		 * Adds a new pending lease for the given user. This is done based on the object passed in. 
		 * The object should be of the following form:
		 * </p>
		 * <p>
		 * {id, lid, numUnits}
		 * </p>
		 * <p>
		 * id is the uid of the person doing the leasing, lid is the uid of the person who is getting the leased
		 * units and numUnits is the number of units being leased. Must call
		 * confirmUserLease to actually confirm the lease. 
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
			if (_userLeaseInfo != null)
				_userLeaseInfo.push(leaseInfo);
			else {
				_userLeaseInfo = [];
				_userLeaseInfo.push(leaseInfo);
			}
				
			if (_save.data.users[leaseInfo.id] == undefined || _save.data.users[leaseInfo.id] == null) {
				_save.data.users[leaseInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			}
			if (_save.data.users[leaseInfo.id].leases == undefined || _save.data.users[leaseInfo.id].leases == null) {
				_save.data.users[leaseInfo.id].leases = [];
			}
			_save.data.users[leaseInfo.id].leases.push(leaseInfo);
		}
		
		/**
		 * <p>
		 * Confirms the lease between the users given in the leaseInfo object passed in. Updates the user's 
		 * information so that the number of units they are leasing out is decremented from their total 
		 * number of units and the person they are leasing to has their units increased. This method must be called
		 * only after addUserLease has been called. The object passed in must be of the form: 
		 * </p>
		 * <p>
		 * 	{id, lid, numUnits}
		 * </p>
		 * 
		 * @param leaseInfo The ids of the two parties that wish to confirm their lease
		 * 
		 */		
		public static function confirmUserLease(leaseInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + leaseInfo["id"];
			variables.lid = "" + leaseInfo["lid"];
			variables.numUnits = "" + leaseInfo["numUnits"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/confirmUserLease.php", variables);
			if (_userLeaseInfo != null) {
				for (var i:int = 0; i < _userLeaseInfo.length; i++) {
					if (_userLeaseInfo[i].id == leaseInfo.id && _userLeaseInfo[i].lid == leaseInfo.lid) {
						_userLeaseInfo[i].pending = 0;
					}
				}
			}
			
			if (_save.data.users[leaseInfo.id] == undefined || _save.data.users[leaseInfo.id] == null) {
				_save.data.users[leaseInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			} else {
				for (i = 0; i < _save.data.users[leaseInfo.id].leases.length; i++) {
					if (_save.data.users[leaseInfo.id].leases[i].id == leaseInfo.id && _save.data.users[leaseInfo.id].leases[i].lid == leaseInfo.lid) {
						_save.data.users[leaseInfo.id].leases[i].pending = 0;
					}
				}
			}
		}
		
		/**
		 * <p>
		 * Rejects the lease between the users given in the leaseInfo object passed in. This method must be called
		 * only after addUserLease has been called. The object passed in must be of the form: 
		 * </p>
		 * <p>
		 * 	{id, lid}
		 * </p>
		 * 
		 * @param leaseInfo The ids of the two parties that wish to confirm their lease
		 * 
		 */	
		public static function rejectUserLease(leaseInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + leaseInfo["id"];
			variables.lid = "" + leaseInfo["lid"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/rejectUserLease.php", variables);
			if (_userLeaseInfo != null) {
				for (var i:int = 0; i < _userLeaseInfo.length; i++) {
					if (_userLeaseInfo[i].id == leaseInfo.id && _userLeaseInfo[i].lid == leaseInfo.lid) {
						_userLeaseInfo.splice(i,1);
					}
				}
			}
			
			if (_save.data.users[leaseInfo.id] == undefined || _save.data.users[leaseInfo.id] == null) {
				_save.data.users[leaseInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			} else {
				for (i = 0; i < _save.data.users[leaseInfo.id].leases.length; i++) {
					if (_save.data.users[leaseInfo.id].leases[i].id == leaseInfo.id && _save.data.users[leaseInfo.id].leases[i].lid == leaseInfo.lid) {
						_save.data.users[leaseInfo.id].leases.splice(i, 1);
					}
				}
			}
		}
		
		/**
		 * <p>
		 * Removes the lease information for the given user from the object who has a lease contract 
		 * with the user who has lid in the given object. Increments the units for the user with uid = id
		 * and decrements the units for the user with uid = lid by numUnits. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {id, lid}
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
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/removeUserLease.php", variables);
			for (var i:int = 0; i < _userLeaseInfo.length; i++) {
				if (_userLeaseInfo[i].id == leaseInfo["id"] && _userLeaseInfo[i].lid == leaseInfo["lid"] 
					&& _userLeaseInfo[i].numUnits == leaseInfo["numUnits"]) {
					_userLeaseInfo.splice(i, 1);
					break;
				}
			}
			if (_save.data.users[leaseInfo.id] == undefined || _save.data.users[leaseInfo.id] == null)
				_save.data.users[leaseInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			var userLeases:Array = _save.data.users[leaseInfo.id].leases;
			for (i = 0; i < userLeases.length; i++) {
				if (userLeases[i].id == leaseInfo["id"] && userLeases[i].lid == leaseInfo["lid"] 
					&& userLeases[i].numUnits == leaseInfo["numUnits"]) {
					userLeases.splice(i, 1);
					if (_save.data.users[leaseInfo.id] != undefined || _save.data.users[leaseInfo.id] != null)
						_save.data.users[leaseInfo.id].leases = userLeases;
					break;
				}
			}
		}
		
		/**
		 * <p>
		 * Inserts the given attack information into the database. Must call isBeingAttacked first to
		 * determine if the user is already being detected. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {uid, aid, leftSide, rightSide}
		 * </p>
		 * 
		 * @param attackInfo must be of the specified format and != null
		 * 
		 */
		public static function updateUserAttacks(attackInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + attackInfo["uid"];
			variables.aid = "" + attackInfo["aid"];
			variables.leftSide = "" + attackInfo["leftSide"];
			variables.rightSide = "" + attackInfo["rightSide"];
			variables.time = attackInfo["time"];
			attackInfo["win"] = -1;
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/updateUserAttacks.php", variables);
			if (_save.data.users[attackInfo.id] == null || _save.data.users[attackInfo.id] == undefined) {
				_save.data.users[attackInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			}
			_save.data.users[attackInfo.id].attacks.push(attackInfo);
		}
		
		/**
		 * <p>
		 * Updates the win status for the given attack pair to the given value. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {uid, aid, win}
		 * </p>
		 * <p>
		 * The win field should be greate than or equal to 0, 0 means the uid lost the attack
		 * and greate than 0 means that uid won the attack. 
		 * </p>
		 * 
		 * @param attackInfo must be of the specified format and != null
		 * 
		 */
		public static function setWinStatusAttacks(attackInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + attackInfo["uid"];
			variables.aid = "" + attackInfo["aid"];
			variables.win = "" + attackInfo["win"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/setWinStatusAttacks.php", variables);
			if (_save.data.users[attackInfo.id] == null || _save.data.users[attackInfo.id] == undefined) {
				_save.data.users[attackInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			}
			for (var i:int = 0; i < _save.data.users[attackInfo.id].attacks.length; i++) {
				if (_save.data.users[attackInfo.id].attacks[i].uid == attackInfo.uid &&
					_save.data.users[attackInfo.id].attacks[i].aid == attackInfo.aid) {
					_save.data.users[attackInfo.id].attacks[i].win = attackInfo["win"];
				}
			}
		}
		
		/**
		 * <p>
		 * Removes the given attack information from the database. The The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {id, aid}
		 * </p>
		 * 
		 * @param attackInfo must be of the specified format and != null
		 * 
		 */
		public static function removeUserAttacks(attackInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + attackInfo["id"];
			variables.aid = "" + attackInfo["aid"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/removeUserAttacks.php", variables);
			if (_pendingAttacks != null) {
				for (var i:int = 0; i < _pendingAttacks.length; i++) {
					if (_pendingAttacks[i].id == attackInfo["id"] && _pendingAttacks[i].aid == attackInfo["aid"]) {
						_pendingAttacks.splice(i, 1);
						break;
					}
				}	
			}
			if (_save.data.users[attackInfo.id] == undefined || _save.data.users[attackInfo.id] == null)
				_save.data.users[attackInfo.id] = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			var userAttacks:Array = _save.data.users[attackInfo.id].attacks;
			for (i = 0; i < userAttacks.length; i++) {
				if (userAttacks[i].id == attackInfo["id"] && userAttacks[i].aid == attackInfo["aid"]) {
					userAttacks.splice(i, 1);
					if (_save.data.users[attackInfo.id] != undefined || _save.data.users[attackInfo.id] != null)
						_save.data.users[attackInfo.id].attacks = userAttacks;
					break;
				}
			}
		}
		
		/**
		 * <p>
		 * Inserts the given upgrade information into the database. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {uid, upid, xpos, ypos}
		 * </p>
		 * 
		 * @param attackInfo must be of the specified format and != null
		 * 
		 */
		public static function insertUserUpgrade(userUpgrades:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + userUpgrades["id"];
			variables.upid = "" + userUpgrades["upid"];
			variables.xpos = "" + userUpgrades["xpos"];
			variables.ypos = "" + userUpgrades["ypos"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/insertUserUpgrades.php", variables);
			if (_save.data.users[userUpgrades.id] == null) {
				_save.data.users[userUpgrades.id].upgrades = {info: {}, tut: {}, leases: [], attacks: [], upgrades: []};
			}
			_save.data.users[userUpgrades.id].upgrades.push(userUpgrades);
		}
		
		/**
		 * <p>
		 * Inserts the given user defence information into the database. The parameter is an array
		 * of objects. The object passed must be of
		 * the following format:
		 * </p>
		 * <p>
		 * {id, did, xpos, ypos}
		 * </p>
		 * 
		 * @param userDefs must be of the specified format and != null
		 * 
		 */
		public static function insertUserDef(userDefs:Array):void
		{
			for each (var def:Object in userDefs) {
				var variables:URLVariables = new URLVariables();
				variables.uid = "" + def["id"];
				variables.did = "" + def["did"];
				variables.xpos = "" + def["xpos"];
				variables.ypos = "" + def["ypos"];
				update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/insertUserDefs.php", variables);
			}
			if (_save.data.users[userDefs.id] == null) {
				_save.data.users[userDefs.id] = {info: {}, tut: {}, defs: [], leases: [], attacks: [], upgrades: []};
			}
			_save.data.users[userDefs.id].defs.push(userDefs);
		}
		
		/**
		 * Starts the saving feature implemented by Flixel. This function must be called at the beginning of
		 * the game to ensure that the save object is instantiated so save users data to the cache.  
		 * 
		 */		
		public static function load():void
		{
			_save = new FlxSave();
			_loaded = _save.bind("users");
			if (_loaded && _save.data.users == null) {
				_save.data.users = [];
			}
		}
	}
}
