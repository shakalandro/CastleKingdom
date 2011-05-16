package
{
	import com.facebook.graph.*;
	import com.facebook.graph.data.*;
	
	import org.flixel.*;
	
	public class LoginState extends GameState
	{
		private const BUTTON_SEPARATION:Number = 40;
		
		private var _startButton:FlxButton;
		private var _helpButton:FlxButton;
		
		public function LoginState()
		{
			super();
		}
		
		override public function create():void {
			super.create();
			add(new FlxSprite(0, 0, Util.assets[Assets.LOGIN_BACKGROUND]));

			if (CastleKingdom.FACEBOOK_ON) {
				_startButton = new FlxButton(0, 0, "Play", login);
			} else {
				_startButton = new FlxButton(0, 0, "Play", start);
			}
			
			_startButton.makeGraphic(250, 100, 0x00000000, true);
			_startButton.y = 325;
			_startButton.x = 50;
			_startButton.width = 250;
			_startButton.height = 100;
			add(_startButton);
			
			
			_helpButton = new FlxButton(0, 0, "Help", function():void {
				drawHelp(CastleKingdom.WIDTH / 4, CastleKingdom.HEIGHT / 4, 
					CastleKingdom.WIDTH / 2, CastleKingdom.HEIGHT / 2);
			});
			_helpButton.x = Util.maxX - _helpButton.width - 10;
			_helpButton.y = Util.maxY - _helpButton.height - 10;
			add(_helpButton);
			
			Database.load();
		}
		
		private function login():void {
			FaceBook.connect(function(ready:Boolean):void {
				CastleKingdom.loading = false;
				if (ready) {
					FaceBook.userInfo(function(fbInfo:Object):void {
						if (fbInfo != null) {
							Util.logObj('fb user info retrieved: ', fbInfo);
							Database.getUserInfo(function(dbInfo:Array):void {
								if (dbInfo == null || dbInfo.length == 0) {
									Util.logObj('New user detected:', fbInfo);
									Database.addNewUser(parseInt(fbInfo.id));
									Castle.tutorialLevel = 0;
									FlxG.switchState(new ActiveState(map));
								} else {
									Util.logObj("Return user detected", dbInfo[0]);
									Database.getUserTutorialInfo(function(info:Object):void {
										setTutorialLevel(info);
										FlxG.switchState(new ActiveState(map));
									}, FaceBook.uid, true);
								}
							}, FaceBook.uid);
						} else {
							Util.log("fbinfo is null or empty");
						}
					}, true);
				} else {
					_startButton.label.text = "Try again :(";
					Util.log("LoginState.login failed: " + ready);
				}
			}, CastleKingdom.flashVars.accessToken);
		}
		
		private function setTutorialLevel(info:Object):void {
			Castle.tutorialLevel = 0;
			if (info == null || info.length == 0) {
				Util.log("tutorial info came back bad: " + info.toString());
			} else {
				Util.logObj("tutorial info came back good: ", info[0]);
				for (var prop:String in info[0]) {
					if (prop != "id") {
						Castle.tutorialLevel = Castle.tutorialLevel + parseInt(info[0][prop]);
					}
				}
			}
		}
		
		private function start():void {
			FlxG.switchState(new ActiveState(this.map));
		}
		
		private function drawHelp(x:Number, y:Number, width:Number, height:Number):void {
			var helpText:String = "This is CastleKingdom! Here, gold is precious and everyone wants yours. " +
				"Defend your castle to protect your treasure. Loot other castles to make a profit.";
			var body:FlxText = new FlxText(0, 0, width, "This is CastleKingdom!");
			body.color = 0x000000;
			pause();
			add(Util.window(x, y, body, unpause, "Help", 0xffffffff, 10, width, height));
		}
	}
}
