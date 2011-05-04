package
{
	import com.facebook.graph.*;
	
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
			
			if (CastleKingdom.FACEBOOK_ON) {
				_startButton = new FlxButton(0, 0, "Play", login);
			} else {
				_startButton = new FlxButton(0, 0, "Play", start);
			}
			Util.center(_startButton);
			_startButton.y -= BUTTON_SEPARATION / 2;
			add(_startButton);
			
			_helpButton = new FlxButton(0, 0, "Help", drawHelp);
			Util.center(_helpButton);
			_helpButton.y += BUTTON_SEPARATION / 2;
			add(_helpButton);
		}
		
		private function login():void {
			FaceBook.connect(function(ready:Boolean):void {
				if (ready) {
					FlxG.switchState(new AttackState(true, false, map));
				} else {
					_startButton.label.text = "Try again :(";
					Util.log("LoginState.login failed: " + ready);
				}
			}, CastleKingdom.flashVars.accessToken);
		}
		
		private function start():void {
			FlxG.switchState(new DefenseState(true, true, this.map));
		}
		
		private function drawHelp(x:Number = CastleKingdom.WIDTH / 4, y:Number = CastleKingdom.HEIGHT / 4, 
								  		width:Number = CastleKingdom.WIDTH / 2, height:Number = CastleKingdom.HEIGHT / 2):void {
			var helpText:String = "This is CastleKingdom! Here, gold is precious and everyone wants yours. " +
				"Defend your castle to protect your treasure. Loot other castles to make a profit.";
			var body:FlxText = new FlxText(0, 0, width, "This is CastleKingdom!");
			body.color = 0x000000;
			pause();
			add(Util.window(x, y, body, unpause, "Help", 0xffffffff, 10, width, height));
		}
	}
}
