package
{
	import flash.events.*;
	import flash.net.*;
	
	import org.flixel.*;

	public class Database
	{
		
		private static var _userInfo:Array;
		private static var _enemyInfo:Array;
		private static var _defUnitInfo:Array;
		
				
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
		
		public static function getMineInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getMineInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.mine, function(unit:XML):Object {
						return {
							id: unit.mid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		public static function getFoundryInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getFoundryInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.foundry, function(unit:XML):Object {
						return {
							id: unit.fid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		public static function getAviaryInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getAviaryInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.aviary, function(unit:XML):Object {
						return {
							id: unit.aid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		public static function getBarracksInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getBarracksInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.barrack, function(unit:XML):Object {
						return {
							id: unit.bid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		public static function getCastleInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getCastleInfo.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.castle, function(unit:XML):Object {
						return {
							id: unit.cid,
							name: unit.name,
							unitWorth: unit.unitWorth,
							goldCost: unit.goldCost
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
			}
		}
		
		public static function getUserLeaseInfo(callback:Function, ids:Object = null, forceRefresh:Boolean = false):void {
			if (forceRefresh || _userInfo == null) {
				getMain("http://games.cs.washington.edu/capstone/11sp/castlekd/database/getUserLeases.php", function(xmlData:XML):void {
					_userInfo = processList(xmlData.user, function(unit:XML):Object {
						return {
							id: unit.uid,
							lid: unit.lid,
							numUnits: unit.numUnits
						};
					})
					callback(_userInfo);
				}, ids);
			} else {
				callback(getAll(_userInfo, ids));
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
		
		public static function updateUserInfo(userInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + userInfo["id"];
			variables.gold = "" + userInfo["gold"];
			variables.units = "" + userInfo["units"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/updateUserInfo.php", variables);
		}
		
		public static function addUserLease(leaseInfo:Object):void
		{
			var variables:URLVariables = new URLVariables();
			variables.uid = "" + leaseInfo["id"];
			variables.lid = "" + leaseInfo["lid"];
			variables.numUnits = "" + leaseInfo["numUnits"];
			update("http://games.cs.washington.edu/capstone/11sp/castlekd/database/addUserLease.php", variables);
		}
		
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