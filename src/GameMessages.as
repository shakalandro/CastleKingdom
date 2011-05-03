package
{
	public class GameMessages
	{
		
		public static const TEXT:Array = new Array();
		public static const NORMAL:Array = new Array();
		public static const BUNNY:Array = new Array();
		
		public static const LOSE_FIGHT:Function = loseFight;
		public static const WIN_FIGHT:Function = winFight;
		public static const LOST_ARMY:Function = loseArmy;
		
		public function GameMessages() {
			TEXT[Assets.SKIN_BUNNY] = BUNNY;
			TEXT[Assets.SKIN_NORMAL] = NORMAL;
			NORMAL["army"] = "armies";
			NORMAL["battle"] = "battle";
			NORMAL["defeated"] = "defeated";
			BUNNY["army"] = "fluffy creatures of love";
			BUNNY["battle"] = "hug war";
			BUNNY["defeated"] = "rejected";
		}
		
		public static function skinStr(text:String):String {
			return text;
			//return TEXT[CastleKingdom.SKIN][text];
		}
		
		public static function winFight(enemy:String, goldWon:int):String {
			return "You have defeated the forces from " + enemy + 
				"\nThe destroyed army dropped " + goldWon + ", which has been added to your gold." ;
		}
		
		public static function loseFight(enemy:String, goldLost:int):String {
			return "You have lost the " + skinStr("battle") + " to forces from " + enemy + 
					"\nThe " + skinStr("army") + " escapes with " + goldLost + " of your gold." ;
		}
		
		public static function loseArmy():String {
			return "Your " + skinStr("army") + " were " +skinStr("defeated") + " in the " + skinStr("battle") + 
				". They won't be returning your gold any time soon";
		}
	}
}