

package
{
	import com.Logging.*;
	
	import flash.geom.Point;
	
	public class Logging
	{
		private var client:CGSClient;
		
		public static const gid:int = 3;
		public static const cid:int = 1;
		public static const vid:int = 2;
		public static const g_name:String = "castlekd";
		
		//this keep track of which level the player is on (the qid)
		private var currentLevel:int;
		
		private var uid:String;
		private var dqid:String;
		
		//keep track the total time it elasped since
		//player has begin a level, use for logging actions
		public static var time:Number = 0;
		
		private const LOGGING:Boolean = true;
		
		public function Logging()
		{
			client = new CGSClient(CGSClientConstants.URL,Logging.gid,Logging.cid,Logging.vid);
			
			client.SetUid(function(val:String):void {
				uid = val;
			});
		}
		
		public function startDquest(level:int):void{
			if (LOGGING){
				trace("reporting new level: "+level);
				currentLevel = level;
				client.SetDqid(function(val:String):void{
					dqid = val;
					client.ReportLevel(dqid,currentLevel,newLevelCallBack);
				});
			}
		}
		private function newLevelCallBack(val:String):void{
			if (val == null){
				trace("fail");
			}else{
				trace("reported new level");
				trace("This is in the newLevelCallBack function");
				trace("\n\n\n" + val + "\n\n\n");
				/*var action:ClientAction = new ClientAction();
				action.aid = 100;
				action.ts = 1;
				action.uid = uid;
				action.detail = new Object();
				action.detail["x"] = 100;
				action.detail["y"] = 100;
				
				client.LogAction(action);*/
			}
		}
		
		
		public function logCastleUpgrade(level:int):void{
		
		if (LOGGING){
		
		var action:ClientAction = new ClientAction();
		action.aid = ClientActionType.CASTLE_UPGRADE;
		action.ts = time; 
		action.uid = uid;
		
		action.detail = new Object();
		action.detail["level"] = level;
		
		client.LogAction(action);
		}
		trace("Castle Upgrade to level "+level);
		}
		
		public function logMineUpgrade(level:int):void{
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.MINE_UPGRADE;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["level"] = level;
				
				client.LogAction(action);
			}
			trace("Mine Upgrade to level "+level);
		}
		
		public function logBarracksUpgrade(level:int):void{
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.BARRACKS_UPGRADE;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["level"] = level;
				
				client.LogAction(action);
			}
			trace("Barracks Upgrade to level "+level);
		}
		
		public function logFoundryUpgrade(level:int):void{
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.FOUNDRY_UPGRADE;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["level"] = level;
				
				client.LogAction(action);
			}
			trace("Foundry Upgrade to level "+level);
		}
		
		public function logAviaryUpgrade(level:int):void{
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.AVIARY_UPGRADE;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["level"] = level;
				
				client.LogAction(action);
			}
			trace("Aviary Upgrade to level "+level);
		}
		
		public function userWinAttackRound(_attackTypeLogging:String, 
										   _towerLogging:String, 
										   _leftArmyLogging:String,
										   _rightArmyLogging:String,
									       _goldWon:int):void{
		
			if (LOGGING){
			
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.WIN_ATTACK;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["type"] = _attackTypeLogging;
				action.detail["towers"] = _towerLogging;
				action.detail["left army"] = _leftArmyLogging;
				action.detail["right army"] = _rightArmyLogging;
				action.detail["gold won"] = _goldWon;
				
				client.LogAction(action);
			}
				trace("User won attack of type "+ _attackTypeLogging);
		}
		
		public function userLoseAttackRound(_attackTypeLogging:String, 
										   _towerLogging:String, 
										   _leftArmyLogging:String,
										   _rightArmyLogging:String,
										   _goldLost:int):void{
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.LOSE_ATTACK;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["type"] = _attackTypeLogging;
				action.detail["towers"] = _towerLogging;
				action.detail["left army"] = _leftArmyLogging;
				action.detail["right army"] = _rightArmyLogging;
				action.detail["gold lost"] = _goldLost;
				
				client.LogAction(action);
			}
			trace("User loss attack of type "+ _attackTypeLogging);
		}
		
		
		/*
		public function logArrowPlaced(index:int, arrowDirection:int):void{
			var point:Point = GameState.getPointFromIndex(index);
			
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.PLACE_ARROW;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["x"] = point.x;
				action.detail["y"] = point.y;
				action.detail["direction"] = arrowDirection;
				
				client.LogAction(action);
			}
			trace("Arrow placed logged at "+point.x+","+point.y);
		}
		*/
		
		/*
		public function logMonsterKilled(x:Number, y:Number):void{
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.KILL_MONSTER;
				action.ts = time; 
				action.uid = uid;
				action.detail = new Object();
				
				action.detail["x"] = x;
				action.detail["y"] = y;
				
				client.LogAction(action);
			}
			trace("monster kill logged at "+x+","+y);
		}*/
		
		/*
		//not used!
		public function logObstacleCrossed(player:Player):void{
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.OBSTACLE_C;
				action.ts = time; 
				action.uid = uid;
				action.detail = new Object();
				
				action.detail["x"] = player.x;
				action.detail["y"] = player.y;
				action.detail["element"]=player.element;
				
				client.LogAction(action);
			}
			trace("player encounter obstacle logged at "+player.x+","+player.y);
		}*/
		
		/*
		public function logLevelClear(level:String):void{
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.CLEAR_LV;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["levelClear"] = level;
				
				client.LogAction(action);
			}
			trace("level clear logged!");
		}
		*/
		
		/*
		public function logLevelFail(level:String):void{
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.FAIL_LV;
				action.ts = time; 
				action.uid = uid;
				
				action.detail = new Object();
				action.detail["levelFail"] = level;
				
				client.LogAction(action);
			}
			trace("level fail logged!");
		}*/
		
		/*
		public function logkillByMonster(x:Number, y:Number,level:String):void{
			if (LOGGING){
				
				var action:ClientAction = new ClientAction();
				action.aid = ClientActionType.KILL_BY_MONSTER;
				action.ts = time; 
				action.uid = uid;
				action.detail = new Object();
				
				action.detail["x"] = x;
				action.detail["y"] = y;
				action.detail["levelFail"] = level;
				
				client.LogAction(action);
			}
			trace("kill by mob: "+ x+","+y + " on " + level);
		}*/
	}
}
